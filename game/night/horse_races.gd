class_name HorseRaces
extends RefCounted

## Las 10 carreras de la noche en el canal hípico de la TV derecha.
##
## Cada caballo tiene una nota pública (lo que ve la casa) y, a veces, viene
## "en forma" sin que la casa lo sepa (las Gafas de culo de vaso lo revelan).
## La carrera se simula en directo: cada caballo avanza según su nota real y
## una forma que fluctúa. El jugador puede ARREAR a su caballo (minijuego de
## timing en la TV 2): un arreo bueno lo acelera un momento; uno malo lo frena.

const RACE_COUNT := 10
const MAX_ODDS := 15.0
const FIRST_RACE := 20      # 18:20
const INTERVAL := 45        # una carrera cada 45 minutos
const RACE_MINUTES := 12    # tope de duración en minutos de reloj (suelen tardar ~7)
const SPEED_K := 1.0 / 120.0
const STEP := 0.05
const MARGIN := 0.85

const NAMES := [
	"Resaca Veloz", "Pata de Palo", "Cuñado Express", "Tortilla Sin Cebolla",
	"Hipoteca Variable", "Lunes Otra Vez", "Don Croqueta", "El Que Nunca Llega",
	"Brisa de Polígono", "Abuela Turbo", "Ticket Perdido", "Sin Cobertura",
	"Calimocho", "Ojo de Halcón", "Siesta Larga", "Carrito del Súper",
	"Mecheros a Euro", "Sopa de Sobre", "Relámpago Gómez", "Ya Si Eso",
	"Pena Penita", "La Yegua Paca", "Bocata de Calamares", "Rotonda Infinita",
]
const COLORS := ["#c0392b", "#2e86c1", "#f1c40f", "#27ae60", "#8e44ad", "#e67e22"]

var races: Array = []
var rng := RandomNumberGenerator.new()

func setup(seed_value: int) -> void:
	rng.seed = hash("horses%d" % seed_value)
	races.clear()
	var names := NAMES.duplicate()
	for r in RACE_COUNT:
		_shuffle(names)
		var horses: Array = []
		for h in 6:
			var rating := rng.randi_range(40, 80)
			horses.append({
				"name": names[h],
				"rating": rating,
				"true_rating": float(rating),
				"color": COLORS[h],
				"odds": 0.0,
			})
		# Soplo: un caballo de cuota media/alta viene en forma y la casa no lo sabe.
		var tip_horse := -1
		if rng.randf() < 0.55:
			var ordered := _sorted_by_rating(horses)
			tip_horse = ordered[rng.randi_range(2, 5)]
			horses[tip_horse]["true_rating"] += rng.randf_range(3.0, 5.0)
		_price(horses)
		races.append({
			"index": r,
			"start": FIRST_RACE + r * INTERVAL,
			"horses": horses,
			"order": [],             # índices de caballo por orden de llegada
			"tip_horse": tip_horse,
			"state": "open",
		})

func _shuffle(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t

func _sorted_by_rating(horses: Array) -> Array:
	var idx := [0, 1, 2, 3, 4, 5]
	idx.sort_custom(func(a, b): return horses[a]["rating"] > horses[b]["rating"])
	return idx

func _price(horses: Array) -> void:
	var total := 0.0
	for h in horses:
		total += exp(float(h["rating"]) / 9.0)
	for h in horses:
		var p := exp(float(h["rating"]) / 9.0) / total
		# La máquina del bar no paga más de 15 a 1: los tapados con soplo y
		# arreos eran una mina (ver BALANCE.md, campaña).
		h["odds"] = snappedf(clampf(MARGIN / p, 1.2, MAX_ODDS), 0.1)

func start_race(race: Dictionary) -> void:
	race["pos"] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	race["form"] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	race["kicks"] = []           # [{horse, mult, until}]
	race["t"] = float(race["start"])
	race["order"] = []
	race["state"] = "running"

## Avanza la simulación hasta el minuto de reloj indicado (con decimales).
func update(clock: float) -> void:
	for race in races:
		if race["state"] != "running":
			continue
		while float(race["t"]) + STEP <= clock and race["state"] == "running":
			race["t"] = float(race["t"]) + STEP
			_step(race)

func _step(race: Dictionary) -> void:
	var t: float = race["t"]
	var pos: Array = race["pos"]
	var form: Array = race["form"]
	var order: Array = race["order"]
	for i in 6:
		if order.has(i):
			continue
		form[i] = float(form[i]) * 0.97 + rng.randfn(0.0, 0.25)
		var v := (1.0 / 7.0) * (1.0 + (float(race["horses"][i]["true_rating"]) - 60.0) * SPEED_K) * (1.0 + 0.15 * float(form[i]))
		for k in race["kicks"]:
			if int(k["horse"]) == i and t <= float(k["until"]):
				v *= float(k["mult"])
		pos[i] = float(pos[i]) + maxf(0.0, v) * STEP
		if float(pos[i]) >= 1.0:
			pos[i] = 1.0
			order.append(i)
	if order.size() >= 6 or t >= float(race["start"]) + RACE_MINUTES:
		# los que no han llegado se ordenan por posición
		var rest := [0, 1, 2, 3, 4, 5].filter(func(h): return not order.has(h))
		rest.sort_custom(func(a, b): return pos[a] > pos[b])
		order.append_array(rest)
		race["state"] = "finished"

## Arreo del jugador: quality 0..1 (1 = centro de la zona verde). Devuelve el texto.
func whip(race: Dictionary, horse: int, quality: float, green_half: float) -> String:
	if race["state"] != "running":
		return ""
	var t: float = race["t"]
	if quality >= 1.0 - green_half * 0.35:
		race["kicks"].append({"horse": horse, "mult": 1.20, "until": t + 0.9})
		return "¡ARREO PERFECTO!"
	if quality >= 1.0 - green_half:
		race["kicks"].append({"horse": horse, "mult": 1.07, "until": t + 0.7})
		return "Buen arreo"
	race["kicks"].append({"horse": horse, "mult": 0.9, "until": t + 0.5})
	return "Fallo: el caballo se asusta"

func winner(race: Dictionary) -> int:
	return int(race["order"][0]) if not race["order"].is_empty() and race["state"] == "done" else -1

func position_of(race: Dictionary, horse: int) -> int:
	return race["order"].find(horse)

func favourite(race: Dictionary) -> int:
	return _sorted_by_rating(race["horses"])[0]

## Siguiente carrera en la que todavía se puede apostar.
func next_open(clock_minute: int) -> Dictionary:
	for r in races:
		if r["state"] == "open" and int(r["start"]) > clock_minute:
			return r
	return {}

func current_running() -> Dictionary:
	for r in races:
		if r["state"] == "running" or r["state"] == "finished":
			return r
	return {}

func open_races(clock_minute: int, limit: int = 3) -> Array:
	var out: Array = []
	for r in races:
		if r["state"] == "open" and int(r["start"]) > clock_minute:
			out.append(r)
			if out.size() >= limit:
				break
	return out

## Posición 0..1 en la pista de un caballo.
func horse_position(race: Dictionary, h: int) -> float:
	if not race.has("pos"):
		return 0.0
	return float(race["pos"][h])

func on_minute(clock_minute: int) -> Array:
	var news: Array = []
	for r in races:
		if r["state"] == "open" and clock_minute >= int(r["start"]):
			start_race(r)
			news.append({"text": "¡Salen los caballos! Carrera %d" % (int(r["index"]) + 1), "kind": "horse"})
		elif r["state"] == "finished":
			r["state"] = "done"
			var w := winner(r)
			news.append({"text": "Carrera %d: gana %s (%.1f)" % [int(r["index"]) + 1, r["horses"][w]["name"], r["horses"][w]["odds"]], "kind": "horse"})
		elif r["state"] == "open" and int(r["start"]) - clock_minute == 5:
			news.append({"text": "Carrera %d en 5 minutos. Últimas apuestas." % (int(r["index"]) + 1), "kind": "info"})
	return news
