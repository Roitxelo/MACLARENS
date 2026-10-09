class_name FootballMarket
extends RefCounted

## Los dos partidos de la noche. Cada partido arranca a su hora, avanza un
## intervalo del MatchSimulator cada 3 minutos de reloj y publica cuotas 1X2.
##
## Las cuotas salen de estadísticas, marcador y minuto. El jugador puede
## empujar el partido con el Búho (¡PENALTI!) o una corazonada (gol).

const MARGIN := 0.90
const BET_CLOSE_MINUTE := 80
const CASHOUT_FACTOR := 0.90

const PLAYERS := {
	"mclarens_fc": ["Bruno Salas", "Quique Mostaza", "El Niño Pardo"],
	"atletico_resaca": ["Toni Ibuprofeno", "Raúl Persiana", "Benja Cubata"],
	"sporting_carbon": ["Iker Hollín", "Paco Brasas", "Rubén Tizón"],
	"dinamo_rotonda": ["El Tanque Morales", "Sergio Ceda", "Luisito Glorieta"],
	"real_cunado": ["Fede Sabelotodo", "Javi Brindis", "Chema Paella"],
	"deportivo_siesta": ["Lolo Bostezo", "Manu Hamaca", "Dani Sofá"],
	"union_tapas": ["Kike Bravas", "Rafa Pincho", "Jose Boquerón"],
	"racing_poligono": ["Toño Nave", "Ismael Grúa", "Edu Palé"],
}

var matches: Array = []   # Array[Dictionary]
var rng := RandomNumberGenerator.new()

func setup(seed_value: int, kickoffs: Array) -> void:
	rng.seed = hash("football%d" % seed_value)
	matches.clear()
	var pool := ["atletico_resaca", "sporting_carbon", "dinamo_rotonda", "real_cunado", "deportivo_siesta", "union_tapas", "racing_poligono"]
	_shuffle(pool)
	# El primero siempre es el derbi del bar: McLarens FC juega en casa.
	var pairs := [["mclarens_fc", pool[0]], [pool[1], pool[2]]]
	for i in kickoffs.size():
		var home_id: String = pairs[i][0]
		var away_id: String = pairs[i][1]
		var fact: MatchFact = null
		if false:  # sin lesiones ocultas en la versión final
			var affected: String = home_id if rng.randf() < 0.5 else away_id
			var roster: Array = PLAYERS.get(affected, ["El Nueve"])
			fact = MatchFact.new({
				"affected_team": affected,
				"affected_player": roster[rng.randi_range(0, roster.size() - 1)],
				"attack_penalty": rng.randf_range(0.18, 0.32),
				"injury_event_bonus": 0.3,
				"active_from_minute": 0,
				"active_until_minute": rng.randi_range(45, 90),
			})
		var sim := MatchSimulator.new({
			"id": "match_%d" % i,
			"home_id": home_id,
			"away_id": away_id,
			"seed": hash("match%d_%d" % [seed_value, i]),
			"match_fact": fact,
		})
		var m := {
			"id": "match_%d" % i,
			"index": i,
			"home_id": home_id,
			"away_id": away_id,
			"home": str(TeamStats.get_team(home_id)["display_name"]),
			"away": str(TeamStats.get_team(away_id)["display_name"]),
			"kickoff": int(kickoffs[i]),
			"sim": sim,
			"fact": fact,
			"state": "pre",
			"minute": 0,
			"events": [],
			"odds": {},
			"prev_odds": {},
		}
		m["odds"] = compute_odds(m)
		m["prev_odds"] = m["odds"].duplicate()
		matches.append(m)

func _shuffle(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = arr[i]
		arr[i] = arr[j]
		arr[j] = t

func get_match(id: String) -> Dictionary:
	for m in matches:
		if m["id"] == id:
			return m
	return {}

## Llamado una vez por cada minuto de reloj. Devuelve los textos de evento
## relevantes de este minuto (para toasts).
func on_minute(clock_minute: int) -> Array:
	var news: Array = []
	for m in matches:
		if m["state"] == "done":
			continue
		var elapsed: int = clock_minute - int(m["kickoff"])
		if elapsed < 0:
			continue
		if m["state"] == "pre":
			m["state"] = "live"
			m["events"].append({"minute": 0, "text": "¡Arranca el partido!", "type": MatchSimulator.EventType.NONE})
			news.append({"text": "¡Empieza %s - %s!" % [m["home"], m["away"]], "kind": "football"})
		if elapsed > 0 and elapsed % MatchSimulator.MINUTES_PER_TICK == 0:
			var sim: MatchSimulator = m["sim"]
			m["prev_odds"] = m["odds"].duplicate()
			var ev := sim.advance_interval()
			m["minute"] = sim.minute
			var t: int = int(ev["event_type"])
			if t != MatchSimulator.EventType.NONE:
				m["events"].append({"minute": sim.minute, "text": str(ev["text"]), "type": t})
				if t == MatchSimulator.EventType.GOAL_HOME or t == MatchSimulator.EventType.GOAL_AWAY:
					news.append({"text": "%d' %s  (%d-%d)" % [sim.minute, ev["text"], sim.home_score, sim.away_score], "kind": "goal",
						"match_id": m["id"], "side": "1" if t == MatchSimulator.EventType.GOAL_HOME else "2"})
				elif t == MatchSimulator.EventType.INJURY_HOME or t == MatchSimulator.EventType.INJURY_AWAY:
					news.append({"text": "%d' %s" % [sim.minute, ev["text"]], "kind": "football"})
			m["odds"] = compute_odds(m)
			if sim.finished:
				m["state"] = "done"
				m["events"].append({"minute": 90, "text": "Final: %d-%d" % [sim.home_score, sim.away_score], "type": MatchSimulator.EventType.NONE})
				news.append({"text": "FINAL  %s %d-%d %s" % [m["home"], sim.home_score, sim.away_score, m["away"]], "kind": "football"})
	return news

## Gol provocado (penalti del Búho o corazonada). side: "1" local, "2" visitante.
func force_goal(m: Dictionary, side: String, reason: String) -> Dictionary:
	var sim: MatchSimulator = m["sim"]
	m["prev_odds"] = m["odds"].duplicate()
	var team: String = m["home"] if side == "1" else m["away"]
	if side == "1":
		sim.home_score += 1
	else:
		sim.away_score += 1
	var text := "¡Gol de %s! (%s)" % [team, reason]
	m["events"].append({"minute": sim.minute, "text": text, "type": MatchSimulator.EventType.GOAL_HOME if side == "1" else MatchSimulator.EventType.GOAL_AWAY})
	m["odds"] = compute_odds(m)
	return {"text": "%d' %s  (%d-%d)" % [sim.minute, text, sim.home_score, sim.away_score], "kind": "goal", "match_id": m["id"], "side": side}

func score_text(m: Dictionary) -> String:
	var sim: MatchSimulator = m["sim"]
	return "%d-%d" % [sim.home_score, sim.away_score]

func result_pick(m: Dictionary) -> String:
	var sim: MatchSimulator = m["sim"]
	if sim.home_score > sim.away_score:
		return "1"
	if sim.home_score < sim.away_score:
		return "2"
	return "X"

func can_bet(m: Dictionary) -> bool:
	return m["state"] == "pre" or (m["state"] == "live" and int(m["minute"]) < BET_CLOSE_MINUTE)

func pick_label(m: Dictionary, pick: String) -> String:
	match pick:
		"1": return m["home"]
		"2": return m["away"]
	return "Empate"

## Cuotas 1X2 desde la vista de la casa: goles restantes como Poisson con
## tasas derivadas de los mismos pesos que usa el simulador por intervalo.
func compute_odds(m: Dictionary) -> Dictionary:
	var sim: MatchSimulator = m["sim"]
	var home := TeamStats.get_team(m["home_id"])
	var away := TeamStats.get_team(m["away_id"])
	var revealed := false
	var fact: MatchFact = m["fact"]
	if fact != null and fact.revealed:
		revealed = true
	var fatigue := minf(float(sim.minute) / 3.0 * 0.01, 0.35)
	var ha := float(home["attack"]) * (1.0 - fatigue)
	var aa := float(away["attack"]) * (1.0 - fatigue)
	if revealed:
		if fact.affected_team == m["home_id"]:
			ha *= 1.0 - fact.attack_penalty
		else:
			aa *= 1.0 - fact.attack_penalty
	var bonus := 1.15 if home.get("home_advantage", false) else 1.0
	var w_home := maxf(0.5, ha - float(away["defense"]) * 0.4) * bonus
	var w_away := maxf(0.5, aa - float(home["defense"]) * 0.4)
	var total := 55.0 + w_home + w_away
	total += maxf(0.2, 10.0 - float(home["discipline"])) + maxf(0.2, 10.0 - float(away["discipline"]))
	total += 3.0 + (ha + aa) * 0.6
	var ticks_left := float(MatchSimulator.MATCH_LENGTH_MINUTES - sim.minute) / float(MatchSimulator.MINUTES_PER_TICK)
	var lam_h := w_home / total * ticks_left
	var lam_a := w_away / total * ticks_left
	var p1 := 0.0
	var px := 0.0
	var p2 := 0.0
	for i in 9:
		for j in 9:
			var p := _poisson(lam_h, i) * _poisson(lam_a, j)
			var hs := sim.home_score + i
			var as_ := sim.away_score + j
			if hs > as_:
				p1 += p
			elif hs == as_:
				px += p
			else:
				p2 += p
	var s := p1 + px + p2
	return {
		"1": _to_odds(p1 / s),
		"X": _to_odds(px / s),
		"2": _to_odds(p2 / s),
	}

func _poisson(lam: float, k: int) -> float:
	var f := 1.0
	for n in range(2, k + 1):
		f *= n
	return exp(-lam) * pow(lam, k) / f

func _to_odds(p: float) -> float:
	p = clampf(p, 0.03, 0.97)
	return snappedf(clampf(MARGIN / p, 1.03, 30.0), 0.01)
