extends Node

## Estado de una run: una noche en el McLarens, de 18:00 a 02:00.
## Autoload "Night". El reloj corre solo; cada minuto de reloj avanza los
## partidos y las carreras. Los minijuegos consumen un bloque de minutos.
##
## Progresión dentro de la noche:
## - Cada juego tiene un personaje con nivel 1-3 (Catalog.CHARACTERS).
## - Objetos (trinkets) comprados en la barra de Lucía modifican pagos.
## - Las mejoras dan herramientas de habilidad, no dinero gratis.
## - RACHA: victorias seguidas multiplican un poco el beneficio (máx. x1,5).

signal changed
signal toast(text: String, kind: String)
signal night_over(reason: String)

const OPEN_HOUR := 18
const NIGHT_LENGTH := 480        # 18:00 -> 02:00
const START_MONEY := 100
const START_DEBT := 500
const BASE_LUCK := 3
const MINUTES_PER_SECOND := 0.6  # la noche dura ~13 min reales a x1
const KICKOFFS := [60, 270]      # 19:00 y 22:30
const SHOP_REFRESH := 90         # la barra cambia de objetos cada hora y media

var seed_value := 0
var money := START_MONEY
var debt := START_DEBT
var luck := BASE_LUCK
var max_luck := BASE_LUCK
var clock := 0.0
var _last_minute := 0
var speed := 1
var running := false
var over := false
var pauses := {}
var bets: Array = []
var history: Array = []
var penalties_used := {}         # match_id -> true
var whips_used := {}             # race_index -> arreos gastados
var perfect_whip := false        # corazonada: el siguiente arreo es perfecto
var tino_forgave := false
var moneda_used := false

var levels := {"buho": 1, "cortado": 1, "chencho": 1, "tino": 1}
var trinkets: Array = []         # ids de Catalog.TRINKETS
var shop: Array = []             # ids en venta ("" = agotado)
var _shop_minute := 0
var streak := 0
var streak_games: Array = []
var sock_used := false
var best_streak := 0
var rng := RandomNumberGenerator.new()

var football := FootballMarket.new()
var races := HorseRaces.new()

func new_night(new_seed: int = -1) -> void:
	seed_value = new_seed if new_seed >= 0 else int(Time.get_unix_time_from_system()) % 100000
	rng.seed = hash("night%d" % seed_value)
	money = START_MONEY
	debt = START_DEBT
	luck = BASE_LUCK
	max_luck = BASE_LUCK
	clock = 0.0
	_last_minute = 0
	speed = 1
	over = false
	running = false
	pauses.clear()
	bets.clear()
	history.clear()
	penalties_used.clear()
	levels = {"buho": 1, "cortado": 1, "chencho": 1, "tino": 1}
	trinkets.clear()
	streak = 0
	streak_games.clear()
	sock_used = false
	best_streak = 0
	whips_used.clear()
	perfect_whip = false
	tino_forgave = false
	moneda_used = false
	football = FootballMarket.new()
	football.setup(seed_value, KICKOFFS)
	races = HorseRaces.new()
	races.setup(seed_value)
	_restock()
	changed.emit()

func start() -> void:
	running = true

func minute() -> int:
	return int(floor(clock))

func clock_text(m: float = -1.0) -> String:
	var mm := int(floor(clock if m < 0.0 else m))
	return "%02d:%02d" % [(OPEN_HOUR + mm / 60) % 24, mm % 60]

func minutes_left() -> int:
	return maxi(0, NIGHT_LENGTH - minute())

func set_pause(reason: String, on: bool) -> void:
	if on:
		pauses[reason] = true
	else:
		pauses.erase(reason)

func is_ticking() -> bool:
	return running and not over and pauses.is_empty()

func toggle_user_pause() -> void:
	set_pause("user", not pauses.has("user"))
	changed.emit()

func cycle_speed() -> void:
	speed = 1 if speed >= 4 else speed * 2
	changed.emit()

func _process(delta: float) -> void:
	if not is_ticking():
		return
	clock = minf(clock + delta * MINUTES_PER_SECOND * speed, float(NIGHT_LENGTH))
	_catch_up()
	races.update(clock)

func advance(minutes: int) -> void:
	clock = minf(float(minute() + minutes), float(NIGHT_LENGTH))
	_catch_up()

func _catch_up() -> void:
	var target := minute()
	while _last_minute < target and not over:
		_last_minute += 1
		races.update(float(_last_minute))
		_on_minute(_last_minute)
	changed.emit()

func _on_minute(m: int) -> void:
	for n in football.on_minute(m):
		toast.emit(n["text"], n["kind"])
	for n in races.on_minute(m):
		toast.emit(n["text"], n["kind"])
	_settle_bets()
	if m - _shop_minute >= SHOP_REFRESH:
		_restock()
		toast.emit("Lucía ha sacado objetos nuevos a la barra.", "info")
	if m >= NIGHT_LENGTH:
		_end("closing")
	elif money < 5 and _open_bets().is_empty() and not pauses.has("minigame"):
		_end("broke")

func _end(reason: String) -> void:
	if over:
		return
	over = true
	running = false
	night_over.emit(reason)

func check_broke() -> void:
	if not over and money < 5 and _open_bets().is_empty() and not pauses.has("minigame"):
		_end("broke")

# --- Dinero, suerte, objetos y niveles ---------------------------------------

func spend(amount: int) -> bool:
	if amount <= 0 or amount > money:
		return false
	money -= amount
	changed.emit()
	return true

func earn(amount: int) -> void:
	money += maxi(0, amount)
	changed.emit()

func spend_luck() -> bool:
	if luck <= 0:
		return false
	luck -= 1
	changed.emit()
	return true

func add_luck() -> bool:
	if luck >= max_luck:
		return false
	luck += 1
	changed.emit()
	return true

func has_trinket(id: String) -> bool:
	return trinkets.has(id)

func level(who: String) -> int:
	return int(levels.get(who, 1))

func round_price(who: String) -> int:
	var lv := level(who)
	var prices: Array = Catalog.CHARACTERS[who]["rounds"]
	if lv >= Catalog.MAX_LEVEL or prices.is_empty():
		return -1
	var p: int = prices[lv]
	if has_trinket("chapa"):
		p = int(round(p * 0.6))
	return p

func buy_round(who: String) -> bool:
	var p := round_price(who)
	if p < 0 or not spend(p):
		return false
	levels[who] = level(who) + 1
	log_moment("Ronda para %s (Nv%d)" % [Catalog.CHARACTERS[who]["name"], level(who)], -p)
	toast.emit("%s sube a nivel %d" % [Catalog.CHARACTERS[who]["name"], level(who)], "win")
	changed.emit()
	return true

func _restock() -> void:
	_shop_minute = _last_minute
	var pool: Array = Catalog.TRINKETS.keys().filter(func(k): return not trinkets.has(k))
	shop.clear()
	for i in 3:
		if pool.is_empty():
			shop.append("")
			continue
		var k: String = pool[rng.randi_range(0, pool.size() - 1)]
		pool.erase(k)
		shop.append(k)
	changed.emit()

func reroll_shop() -> bool:
	if not spend(5):
		return false
	_restock()
	return true

func buy_trinket(slot: int) -> bool:
	var id: String = shop[slot]
	if id == "" or trinkets.size() >= Catalog.MAX_TRINKETS:
		return false
	var price: int = Catalog.TRINKETS[id]["price"]
	if not spend(price):
		return false
	trinkets.append(id)
	shop[slot] = ""
	if id == "trebol":
		max_luck += 1
		luck += 1
	log_moment("Compras %s" % Catalog.TRINKETS[id]["name"], -price)
	toast.emit("Nuevo objeto: %s" % Catalog.TRINKETS[id]["name"], "ticket")
	changed.emit()
	return true

func reduce_debt(amount: int, why: String) -> void:
	debt = maxi(0, debt - amount)
	log_moment(why, amount)
	toast.emit("%s: deuda -%d €" % [why, amount], "win")
	changed.emit()

func log_moment(text: String, delta_money: int) -> void:
	history.append({"time": clock_text(float(_last_minute)), "text": text, "delta": delta_money})

# --- Racha y pagos -----------------------------------------------------------

func streak_mult_preview() -> float:
	return Catalog.streak_mult(streak)

## Toda victoria pasa por aquí: aplica la racha al beneficio (máx. x1,5).
## Devuelve lo que se ingresa (apuesta incluida).
func register_win(game: String, stake: int, gross: int, _tags: Dictionary = {}) -> int:
	var profit := float(maxi(0, gross - stake))
	var mult := 1.0
	if stake >= 10:
		mult = Catalog.streak_mult(streak)
		streak += 1
		if not streak_games.has(game):
			streak_games.append(game)
		best_streak = maxi(best_streak, streak)
	var total := stake + int(round(profit * mult))
	money += total
	changed.emit()
	return total

func register_loss(_game: String) -> void:
	if streak == 0:
		return
	if has_trinket("calcetin") and not sock_used:
		sock_used = true
		toast.emit("El calcetín de la suerte salva tu racha.", "info")
		return
	if streak >= 3:
		toast.emit("Se rompe la racha de %d." % streak, "lose")
	streak = 0
	streak_games.clear()
	sock_used = false
	changed.emit()

func streak_text() -> String:
	if streak == 0:
		return "SIN RACHA"
	return "RACHA %d · próxima victoria x%.1f" % [streak, Catalog.streak_mult(streak)]

# --- Tickets -----------------------------------------------------------------

func _open_bets() -> Array:
	return bets.filter(func(b): return b["status"] == "open")

func open_bets() -> Array:
	return _open_bets()

func place_football(match_id: String, pick: String, stake: int) -> bool:
	var m := football.get_match(match_id)
	if m.is_empty() or not football.can_bet(m):
		return false
	if not spend(stake):
		return false
	var odds: float = m["odds"][pick]
	bets.append({
		"type": "football", "match_id": match_id, "pick": pick, "stake": stake,
		"odds": odds, "status": "open", "payout": 0,
		"label": "%s · %s" % [football.pick_label(m, pick), _short_match(m)],
		"placed_at": clock_text(),
	})
	toast.emit("Ticket: %s @ %.2f (%d €)" % [football.pick_label(m, pick), odds, stake], "ticket")
	return true

func horse_place_odds(h: Dictionary) -> float:
	return snappedf(maxf(1.1, float(h["odds"]) / 3.0), 0.1)

func place_horse(race_index: int, horse: int, stake: int, kind: String = "win") -> bool:
	var race: Dictionary = races.races[race_index]
	if race["state"] != "open" or int(race["start"]) <= minute():
		return false
	if kind == "place" and level("cortado") < 3:
		return false
	if not spend(stake):
		return false
	var h: Dictionary = race["horses"][horse]
	var odds := float(h["odds"]) if kind == "win" else horse_place_odds(h)
	bets.append({
		"type": "horse", "race": race_index, "horse": horse, "stake": stake, "kind": kind,
		"odds": odds, "status": "open", "payout": 0,
		"label": "C%d · %s%s" % [race_index + 1, h["name"], " (colocado)" if kind == "place" else ""],
		"placed_at": clock_text(),
	})
	toast.emit("Ticket: %s @ %.1f (%d €)" % [h["name"], odds, stake], "ticket")
	return true

func _short_match(m: Dictionary) -> String:
	return "%s-%s" % [str(m["home"]).split(" ")[0], str(m["away"]).split(" ")[0]]

func cashout_value(bet: Dictionary) -> int:
	if bet["status"] != "open" or bet["type"] != "football":
		return 0
	var m := football.get_match(bet["match_id"])
	if m.is_empty() or m["state"] == "done":
		return 0
	var current: float = m["odds"][bet["pick"]]
	var factor := 1.0 if level("buho") >= 2 else FootballMarket.CASHOUT_FACTOR
	return int(round(float(bet["stake"]) * float(bet["odds"]) / maxf(current, 1.01) * factor))

func cashout(bet: Dictionary) -> int:
	var value := cashout_value(bet)
	if value <= 0:
		return 0
	bet["status"] = "cashed"
	bet["payout"] = value
	earn(value)
	log_moment("Cobro anticipado: %s" % bet["label"], value - int(bet["stake"]))
	toast.emit("Cobrado: %d €" % value, "win")
	return value

# --- Habilidades de los personajes ------------------------------------------

func _my_side(match_id: String) -> String:
	for b in bets:
		if b["type"] == "football" and b["match_id"] == match_id and b["status"] == "open" and b["pick"] != "X":
			return b["pick"]
	return ""

## Búho Nv3: una vez por partido, con ticket a un equipo, tiras un penalti.
func can_penalty(match_id: String) -> bool:
	var m := football.get_match(match_id)
	if m.is_empty() or m["state"] != "live" or level("buho") < 3 or penalties_used.has(match_id):
		return false
	return _my_side(match_id) != ""

func penalty_result(match_id: String, scored: bool) -> void:
	if not can_penalty(match_id):
		return
	penalties_used[match_id] = true
	var m := football.get_match(match_id)
	if scored:
		var n := football.force_goal(m, _my_side(match_id), "penalti")
		toast.emit(n["text"], "goal")
	else:
		toast.emit("Penalti fallado. El Búho mira al techo.", "lose")
	changed.emit()

## Cortado: arreos disponibles para tu caballo en la carrera que está corriendo.
func whips_left(race_index: int) -> int:
	var total: int = Catalog.CORTADO_WHIPS[level("cortado") - 1]
	if total > 0 and has_trinket("fusta"):
		total += 2
	return maxi(0, total - int(whips_used.get(race_index, 0)))

func my_horse(race_index: int) -> int:
	for b in bets:
		if b["type"] == "horse" and int(b["race"]) == race_index and b["status"] == "open":
			return int(b["horse"])
	return -1

func whip_green_half() -> float:
	return 0.16 if has_trinket("fusta") else 0.11

## quality: 1 = aguja en el centro de la zona verde, 0 = en el extremo.
func whip(race_index: int, quality: float) -> String:
	var race: Dictionary = races.races[race_index]
	var h := my_horse(race_index)
	if h < 0 or whips_left(race_index) <= 0 or race["state"] != "running":
		return ""
	whips_used[race_index] = int(whips_used.get(race_index, 0)) + 1
	if perfect_whip:
		perfect_whip = false
		quality = 1.0
	var txt := races.whip(race, h, quality, whip_green_half())
	changed.emit()
	return txt

## Corazonada en caballos: el siguiente arreo sale perfecto.
func hunch_whip() -> bool:
	if perfect_whip or not spend_luck():
		return false
	perfect_whip = true
	return true

func _settle_bets() -> void:
	for b in bets:
		if b["status"] != "open":
			continue
		if b["type"] == "football":
			var m := football.get_match(b["match_id"])
			if m["state"] != "done":
				continue
			if football.result_pick(m) == b["pick"]:
				_win(b, "football")
			else:
				_lose(b, "football")
		elif b["type"] == "horse":
			var race: Dictionary = races.races[b["race"]]
			if race["state"] != "done":
				continue
			var pos := races.position_of(race, int(b["horse"]))
			var ok := pos == 0 if b.get("kind", "win") == "win" else pos <= 1
			if ok:
				_win(b, "horse")
			elif pos == 1 and has_trinket("herradura") and b.get("kind", "win") == "win":
				var back := mini(20, int(b["stake"]))
				b["status"] = "refunded"
				b["payout"] = back
				money += back
				toast.emit("Herradura: tu caballo llegó 2.º, recuperas %d €" % back, "info")
			else:
				_lose(b, "horse")

func _win(b: Dictionary, game: String) -> void:
	var gross := int(round(float(b["stake"]) * float(b["odds"])))
	var pay := register_win(game, int(b["stake"]), gross)
	b["status"] = "won"
	b["payout"] = pay
	log_moment("Acierto: %s" % b["label"], pay - int(b["stake"]))
	toast.emit("¡Premio! %s  +%d €" % [b["label"], pay], "win")

func _lose(b: Dictionary, game: String) -> void:
	b["status"] = "lost"
	log_moment("Fallo: %s" % b["label"], -int(b["stake"]))
	toast.emit("Ticket perdido: %s" % b["label"], "lose")
	register_loss(game)

# --- Agenda ------------------------------------------------------------------

func agenda(limit: int = 3) -> Array:
	var items: Array = []
	for m in football.matches:
		if m["state"] == "live":
			items.append({"t": -1, "text": "EN VIVO %s %s %s %d'" % [str(m["home"]).split(" ")[0], football.score_text(m), str(m["away"]).split(" ")[0], int(m["minute"])]})
		elif m["state"] == "pre":
			items.append({"t": int(m["kickoff"]), "text": "%s  Fútbol %s" % [clock_text(m["kickoff"]), _short_match(m)]})
	var running_race := races.current_running()
	if not running_race.is_empty():
		items.append({"t": -1, "text": "EN VIVO Caballos C%d" % (int(running_race["index"]) + 1)})
	for r in races.open_races(minute(), 2):
		items.append({"t": int(r["start"]), "text": "%s  Caballos C%d" % [clock_text(r["start"]), int(r["index"]) + 1]})
	items.sort_custom(func(a, b): return a["t"] < b["t"])
	return items.slice(0, limit)
