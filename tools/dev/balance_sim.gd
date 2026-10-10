extends SceneTree

## T05 — Simulador de equilibrio. Juega noches completas con bots de distinto
## nivel de habilidad usando las reglas reales (night_state, mercados,
## carreras, catálogo). Los minijuegos de habilidad (arreo, billar, cartas)
## se modelan con probabilidades de acierto declaradas abajo.
##
## Uso: godot --headless --path game -s res://../tools/dev/balance_sim.gd -- [noches] [deuda]

const PROFILES := {
	# whip: probabilidad de arreo [perfecto, bueno] (el resto, fallo) · billar: acierto por tiro según nivel de Tino
	# cards: "count" cuenta cartas, "naive" solo mira la carta actual, "none" no juega
	"azar": {"whip": [0.05, 0.15], "billar": [0.30, 0.15, 0.06], "cards": "naive", "smart_bets": false, "shop": false, "max_hands": 3},
	"normal": {"whip": [0.15, 0.35], "billar": [0.55, 0.35, 0.18], "cards": "naive", "smart_bets": true, "shop": true, "max_hands": 4},
	"habil": {"whip": [0.30, 0.40], "billar": [0.80, 0.60, 0.40], "cards": "count", "smart_bets": true, "shop": true, "max_hands": 6},
}

var rng := RandomNumberGenerator.new()
var hands_played := 0
var p: Dictionary

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var nights := int(args[0]) if args.size() > 0 else 200
	var debt := int(args[1]) if args.size() > 1 else 500
	if args.size() > 2 and args[2] == "ev":
		_ev(nights)
		quit()
		return
	print("Noches por perfil: %d · deuda: %d €" % [nights, debt])
	var profs := ["azar", "normal", "habil"]
	if OS.get_environment("BAL_PROF") != "":
		profs = [OS.get_environment("BAL_PROF")]
	for prof in profs:
		p = PROFILES[prof]
		var paid := 0
		var finals: Array = []
		for s in nights:
			var money := _play_night(1000 + s, debt)
			finals.append(money)
			if money >= _night.debt:
				paid += 1
		finals.sort()
		print("%-7s paga a Tino %5.1f %%   mediana %4d €   p10 %4d €   p90 %4d €" % [prof, 100.0 * paid / nights, finals[nights / 2], finals[nights / 10], finals[nights * 9 / 10]])
	quit()

var _night: Node

func _play_night(seed_value: int, debt: int) -> int:
	if _night != null:
		_night.free()
	_night = load("res://night/night_state.gd").new()
	var n = _night
	n.new_night(seed_value)
	n.debt = debt
	if OS.get_environment("BAL_START") != "":
		n.money = int(OS.get_environment("BAL_START"))
	n.running = true
	rng.seed = seed_value * 31
	hands_played = 0
	var billar_tries := 0
	while not n.over and n.minute() < n.NIGHT_LENGTH:
		var m: int = n.minute()
		if p["shop"]:
			_shop(n)
		_horses(n, m)
		_football(n, m)
		# huecos: cartas o billar si no hay carrera en los próximos 25 min
		var nxt: Dictionary = n.races.next_open(m)
		var gap: bool = nxt.is_empty() or int(nxt["start"]) - m > 25
		if gap and not _has_live_bet(n):
			var bl: int = n.level("tino")
			# juega si cree que la serie compensa con lo que paga Tino en ese nivel
			var q: float = p["billar"][bl - 1]
			var pwin := q * q * (3.0 - 2.0 * q)
			var billar_ok: bool = pwin * (1 + Catalog.TINO_PAYOUT[bl - 1]) > 1.0 or not p["smart_bets"]
			if billar_tries < 6 and billar_ok and n.money >= 40:
				billar_tries += 1
				_billar(n)
				continue
			var cards_ok: bool = not p["smart_bets"] or n.level("chencho") >= 2
			if cards_ok and p["cards"] != "none" and hands_played < p["max_hands"] and n.money >= 30:
				hands_played += 1
				_cards(n)
				continue
		n.advance(1)
	if OS.get_environment("BAL_DEBUG") != "":
		for h in n.history:
			print("   ", h["time"], " ", h["text"], " ", h["delta"])
		print("   fin ", n.clock_text(), " dinero ", n.money, " over ", n.over)
	return n.money

func _has_live_bet(n) -> bool:
	for b in n.open_bets():
		if b["type"] == "football":
			var mm: Dictionary = n.football.get_match(b["match_id"])
			if mm["state"] == "live":
				return true
	return false

# --- Tienda ------------------------------------------------------------------

func _shop(n) -> void:
	# Compra solo lo que su estilo de juego amortiza.
	if n.level("cortado") < 2 and n.money >= 130:
		n.buy_round("cortado")
	for i in 3:
		var id: String = n.shop[i]
		var wanted := ["gafas", "fusta"]
		if p["billar"][0] >= 0.5:
			wanted.append_array(["tiza", "taco"])
		if id in wanted and n.money >= int(Catalog.TRINKETS[id]["price"]) + 90:
			n.buy_trinket(i)
	if n.level("cortado") == 2 and n.money >= 220:
		n.buy_round("cortado")
	if n.level("buho") < 2 and n.money >= 200:
		n.buy_round("buho")
	if p["cards"] == "count" and n.level("chencho") < 2 and n.money >= 180:
		n.buy_round("chencho")

# --- Caballos ---------------------------------------------------------------------

func _horses(n, m: int) -> void:
	for r in n.races.races:
		if r["state"] == "open" and int(r["start"]) - m == 2 and n.my_horse(int(r["index"])) < 0:
			var pick := -1
			var stake := 10
			var bank: int = n.money
			if p["smart_bets"]:
				# Solo apuesta cuando tiene ventaja: caballo en forma (gafas) o favorito con arreos buenos.
				if n.has_trinket("gafas") and int(r["tip_horse"]) >= 0:
					pick = int(r["tip_horse"]); stake = clampi(bank / 6, 10, 60)
				elif n.level("cortado") >= 3 or (n.level("cortado") >= 2 and n.has_trinket("fusta")):
					pick = n.races.favourite(r); stake = clampi(bank / 8, 10, 40)
			else:
				pick = rng.randi_range(0, 5); stake = 10
			if pick >= 0 and n.money >= stake + 10:
				n.place_horse(int(r["index"]), pick, stake)
		if r["state"] == "running" and n.my_horse(int(r["index"])) >= 0:
			while n.whips_left(int(r["index"])) > 0 and float(r["t"]) - float(r["start"]) > 1.0:
				if n.whip(int(r["index"]), _whip_q(n)) == "":
					break

func _whip_q(n) -> float:
	var r := rng.randf()
	if r < p["whip"][0]:
		return 1.0
	if r < p["whip"][0] + p["whip"][1]:
		return 1.0 - n.whip_green_half() * 0.6
	return 0.0

# --- Fútbol -------------------------------------------------------------------------

func _football(n, m: int) -> void:
	for mm in n.football.matches:
		var mine: Array = n.bets.filter(func(b): return b["type"] == "football" and b["match_id"] == mm["id"])
		if p["smart_bets"] and n.level("buho") >= 2:
			if mm["state"] == "live" and int(mm["minute"]) in range(6, 72) and mine.is_empty():
				var pr: Dictionary = (mm["sim"] as MatchSimulator).pressure()
				var st := clampi(n.money / 6, 10, 60)
				if pr["home_share"] > 0.68 and n.money >= st + 20:
					n.place_football(mm["id"], "1", st)
				elif pr["home_share"] < 0.32 and n.money >= st + 20:
					n.place_football(mm["id"], "2", st)
			for b in mine:
				if b["status"] == "open":
					var v: int = n.cashout_value(b)
					if v >= int(b["stake"]) * 1.6:
						n.cashout(b)
		elif not p["smart_bets"]:
			if mm["state"] == "pre" and int(mm["kickoff"]) - m == 5 and mine.is_empty() and n.money >= 30:
				n.place_football(mm["id"], ["1", "X", "2"][rng.randi_range(0, 2)], 20)

# --- Billar (modelo) -------------------------------------------------------------------

func _billar(n) -> void:
	var lv: int = n.level("tino")
	var stake: int = clampi(int(n.money * (0.4 if p["smart_bets"] else 0.2)), 10, Catalog.TINO_MAX_STAKE[lv - 1])
	var acc: float = p["billar"][lv - 1]
	if n.has_trinket("tiza"): acc += 0.08
	if n.has_trinket("taco"): acc += 0.05
	var made := 0
	for i in 3:
		if rng.randf() < acc:
			made += 1
	n.spend(mini(stake, n.money))
	n.log_moment("billar Nv%d: %d/3" % [lv, made], 0)
	if made >= 2:
		n.register_win("billar", stake, stake * (1 + int(Catalog.TINO_PAYOUT[lv - 1])))
		if lv >= 3:
			if not n.tino_forgave:
				n.tino_forgave = true
				n.reduce_debt(100, "Tino")
		else:
			n.levels["tino"] = lv + 1
	else:
		n.register_loss("billar")
	n.advance(20)

# --- Cartas (mismas fórmulas que mayor_menor.gd) ---------------------------------------

const VALUES := [1, 2, 3, 4, 5, 6, 7, 10, 11, 12]

func _cards(n) -> void:
	var lv: int = n.level("chencho")
	var stake := mini(Catalog.CHENCHO_MAX[lv - 1], 20 if p["cards"] == "naive" else Catalog.CHENCHO_MAX[lv - 1])
	if not n.spend(stake):
		return
	n.advance(5)
	var deck: Array = []
	for s in 4:
		for v in VALUES:
			deck.append(VALUES.find(v))
	for i in range(deck.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = deck[i]; deck[i] = deck[j]; deck[j] = t
	var cur: int = deck.pop_back()
	var pot := stake
	var steps := 0
	var insured := false
	while steps < 6:
		var hi := 0
		var lo := 0
		for c in deck:
			if c > cur: hi += 1
			elif c < cur: lo += 1
		var dir := 1
		if p["cards"] == "count":
			dir = 1 if hi >= lo else -1
		else:
			dir = 1 if cur < 5 else -1
		var p_true := float(hi if dir > 0 else lo) / maxf(1.0, float(hi + lo))
		if steps > 0:
			var stop := 0.7 if p["cards"] == "count" else 0.0
			if p_true < stop or (p["cards"] == "naive" and steps >= 2) or (p["cards"] == "count" and steps >= 4):
				break
		var p_house: float
		if lv >= 3:
			p_house = float((VALUES.size() - 1 - cur) if dir > 0 else cur) / float(VALUES.size() - 1)
		else:
			p_house = p_true
		if p_house <= 0.0 or p_true <= 0.0:
			break
		var mult := snappedf(clampf(0.95 / p_house, 1.05, 12.0), 0.05)
		var nxt: int = deck.pop_back()
		if nxt == cur:
			continue
		if (nxt > cur) == (dir > 0):
			steps += 1
			pot = int(round(pot * mult))
			cur = nxt
		else:
			n.register_loss("cards")
			if lv >= 2 and not insured and steps > 0:
				n.earn(pot / 2)
			return
	n.log_moment("cartas Nv%d: %d aciertos, bote %d" % [lv, steps, pot], 0)
	if steps > 0:
		n.register_win("cards", stake, pot)
	else:
		n.earn(stake)


# --- Valor esperado por actividad (beneficio medio por € apostado) ------------

func _ev(trials: int) -> void:
	print("EV por actividad (beneficio medio por cada € apostado), %d pruebas" % trials)
	var only := OS.get_cmdline_user_args()[3] if OS.get_cmdline_user_args().size() > 3 else "hcf"
	for prof in ["azar", "normal", "habil"]:
		p = PROFILES[prof]
		if not "h" in only:
			pass
		else:
			_ev_horses(prof, trials)
		if "c" in only:
			_ev_cards(prof, trials)
		if "f" in only:
			_ev_football(prof, trials)

func _ev_horses(prof: String, trials: int) -> void:
	if true:
		# caballos: favorito / caballo en forma, con arreos de Cortado Nv2 y Nv3+fusta
		for setup in [["fav sin arreos", 1, false, false], ["fav Nv2", 2, false, false], ["fav Nv3+fusta", 3, true, false], ["en forma Nv3+fusta+gafas", 3, true, true]]:
			var staked := 0.0
			var ret := 0.0
			for t in trials:
				var n = load("res://night/night_state.gd").new()
				n.new_night(5000 + t)
				n.money = 10000
				n.running = true
				n.levels["cortado"] = setup[1]
				if setup[2]: n.trinkets.append("fusta")
				var r: Dictionary = n.races.races[t % 10]
				n.advance(int(r["start"]) - 3)
				var pick: int = n.races.favourite(r)
				if setup[3]:
					if int(r["tip_horse"]) < 0:
						n.free()
						continue
					pick = int(r["tip_horse"])
				var before: int = n.money
				n.place_horse(int(r["index"]), pick, 10)
				staked += 10.0
				var guard := 0
				while r["state"] != "done" and guard < 40:
					n.advance(1)
					guard += 1
					if r["state"] == "running":
						while n.whips_left(int(r["index"])) > 0:
							if n.whip(int(r["index"]), _whip_q(n)) == "":
								break
				ret += float(n.money - before + 10)
				n.free()
			print("  %-7s caballos %-26s EV %+.2f" % [prof, setup[0], (ret - staked) / maxf(staked, 1.0)])
func _ev_cards(prof: String, trials: int) -> void:
	if true:
		for lv in [1, 2, 3]:
			var staked2 := 0.0
			var ret2 := 0.0
			for t in trials:
				var n = load("res://night/night_state.gd").new()
				n.new_night(7000 + t)
				n.money = 10000
				n.levels["chencho"] = lv
				var stake := 20
				var before: int = n.money
				hands_played = 0
				_cards(n)
				staked2 += stake
				ret2 += float(n.money - before + stake)
				n.free()
			print("  %-7s cartas Chencho Nv%d                EV %+.2f" % [prof, lv, (ret2 - staked2) / staked2])
func _ev_football(prof: String, trials: int) -> void:
	if true:
		var staked3 := 0.0
		var ret3 := 0.0
		for t in trials / 2:
			var n = load("res://night/night_state.gd").new()
			n.new_night(9000 + t)
			n.money = 10000
			n.running = true
			n.levels["buho"] = 2
			var before: int = n.money
			var guard := 0
			while n.football.matches[0]["state"] != "done" and guard < 200:
				_football(n, n.minute())
				n.advance(1)
				guard += 1
			for b in n.bets:
				staked3 += float(b["stake"])
			ret3 += float(n.money - before)
			n.free()
		print("  %-7s fútbol (presión, Búho Nv2) EV %+.2f  (%.0f € apostados)" % [prof, ret3 / maxf(staked3, 1.0), staked3])
