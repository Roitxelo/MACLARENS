class_name InfoBoard
extends RefCounted

## Periódico y red de contactos. Nunca leen el resultado directamente para
## mostrarlo: generan afirmaciones que aciertan o fallan según la fiabilidad
## de cada fuente. El jugador decide a quién creer.

const CONTACTS := {
	"lucia": {"name": "Lucía", "football": 0.75, "horses": 0.80, "style": "fiable"},
	"buho": {"name": "El Búho", "football": 0.85, "horses": 0.45, "style": "futbolero"},
	"tino": {"name": "Tino", "football": 0.40, "horses": 0.35, "style": "interesado"},
}

var rng := RandomNumberGenerator.new()
var football: FootballMarket
var horses: HorseRaces
var paper_football: Array = []   # [{title, body}]
var paper_horses: Array = []     # [{race, text}]
var calls_made := {}
const MAX_CALLS := 3          # llamadas por contacto y noche
const MAX_BAR_CHATS := 2

func setup(seed_value: int, fm: FootballMarket, hr: HorseRaces) -> void:
	rng.seed = hash("info%d" % seed_value)
	football = fm
	horses = hr
	calls_made.clear()
	_write_paper()

func _write_paper() -> void:
	paper_football.clear()
	paper_horses.clear()
	for m in football.matches:
		var fact: MatchFact = m["fact"]
		var title := "%s - %s" % [m["home"], m["away"]]
		var body := ""
		if fact != null:
			var team_name: String = m["home"] if fact.affected_team == m["home_id"] else m["away"]
			if rng.randf() < 0.75:
				body = "Parte médico: %s (%s) arrastra molestias. Su técnico: \"Está para jugar\"." % [fact.affected_player, team_name]
			else:
				body = "%s llega en plena forma, según su vestuario. Nadie habla de lesiones." % team_name
		else:
			var team_id: String = m["home_id"] if rng.randf() < 0.5 else m["away_id"]
			var roster: Array = FootballMarket.PLAYERS.get(team_id, ["El Nueve"])
			var player: String = roster[rng.randi_range(0, roster.size() - 1)]
			if rng.randf() < 0.5:
				body = "Se habló de unas molestias de %s, pero entrenó con normalidad." % player
			else:
				body = "Rumor: %s salió anoche de fiesta. El club lo niega." % player
		paper_football.append({"title": title, "body": body, "time": m["kickoff"]})
	# Hípica: soplos de cuadra para 4 carreras. ~70% apuntan al caballo real en forma.
	var picks := [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
	for i in range(picks.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = picks[i]
		picks[i] = picks[j]
		picks[j] = t
	for k in 4:
		var race: Dictionary = horses.races[picks[k]]
		var hidx: int = race["tip_horse"]
		if hidx < 0 or rng.randf() > 0.7:
			hidx = rng.randi_range(0, 5)
		paper_horses.append({"race": int(race["index"]), "text": "C%d · En la cuadra de %s dicen que vuela." % [int(race["index"]) + 1, race["horses"][hidx]["name"]]})
	paper_horses.sort_custom(func(a, b): return a["race"] < b["race"])

## Siguiente partido en el que todavía se puede apostar.
func next_match(clock_minute: int) -> Dictionary:
	for m in football.matches:
		if football.can_bet(m):
			return m
	return {}

func call_contact(id: String, topic: String, clock_minute: int) -> String:
	var c: Dictionary = CONTACTS[id]
	calls_made[id] = int(calls_made.get(id, 0)) + 1
	if topic == "horses":
		var race := horses.next_open(clock_minute)
		if race.is_empty():
			return "%s: \"Hoy ya no quedan carreras, majo.\"" % c["name"]
		var w := horses.winner(race)
		var hidx := w
		if rng.randf() > float(c["horses"]):
			hidx = rng.randi_range(0, 5)
			if id == "tino":
				# Tino siempre empuja hacia cuotas largas: a él le pagan comisión.
				var longest := 0
				for i in 6:
					if race["horses"][i]["odds"] > race["horses"][longest]["odds"]:
						longest = i
				hidx = longest if rng.randf() < 0.6 else hidx
		var hname: String = race["horses"][hidx]["name"]
		match id:
			"lucia": return "Lucía: \"En la carrera %d, %s. Me lo ha dicho el mozo de cuadra.\"" % [int(race["index"]) + 1, hname]
			"buho": return "El Búho: \"De caballos sé poco... pero en la %d me gusta %s.\"" % [int(race["index"]) + 1, hname]
		return "Tino: \"Carrera %d. %s. Hazme caso, que yo sé de esto.\"" % [int(race["index"]) + 1, hname]
	var m := next_match(clock_minute)
	if m.is_empty():
		return "%s: \"El fútbol ya ha acabado por hoy.\"" % c["name"]
	var fact: MatchFact = m["fact"]
	var truthful := rng.randf() < float(c["football"])
	var claim := ""
	if fact != null and truthful:
		var team: String = m["home"] if fact.affected_team == m["home_id"] else m["away"]
		claim = "%s no está bien. %s lo va a notar." % [fact.affected_player, team]
	elif fact == null and truthful:
		claim = "En %s - %s no hay nada raro. Que gane el mejor." % [m["home"], m["away"]]
	else:
		var team_id: String = m["home_id"] if rng.randf() < 0.5 else m["away_id"]
		if fact != null and rng.randf() < 0.6:
			claim = "Todo en orden en %s - %s, nadie está tocado." % [m["home"], m["away"]]
		else:
			var roster: Array = FootballMarket.PLAYERS.get(team_id, ["El Nueve"])
			var team_name := str(TeamStats.get_team(team_id)["display_name"])
			claim = "%s está tocado. %s va a sufrir." % [roster[rng.randi_range(0, roster.size() - 1)], team_name]
	match id:
		"lucia": return "Lucía: \"%s\"" % claim
		"buho": return "El Búho: \"Hablé con el utillero. %s\"" % claim
	return "Tino: \"%s Y apuesta fuerte, que me debes dinero.\"" % claim

func calls_left(id: String) -> int:
	return maxi(0, MAX_CALLS - int(calls_made.get(id, 0)))

func bar_chats_left() -> int:
	return maxi(0, MAX_BAR_CHATS - int(calls_made.get("bar", 0)))

## Rumor rápido de la barra (Lucía en persona): fiable, sobre lo próximo.
func bar_rumour(clock_minute: int) -> String:
	calls_made["bar"] = int(calls_made.get("bar", 0)) + 1
	calls_made["lucia"] = int(calls_made.get("lucia", 0)) - 1  # no gasta llamadas del teléfono
	if rng.randf() < 0.5:
		return call_contact("lucia", "horses", clock_minute)
	return call_contact("lucia", "football", clock_minute)
