class_name OddsEngine
extends RefCounted

## Convierte el estado visible de un MatchSimulator en una cuota de "gana
## el local". Solo lee estadísticas públicas de equipo, marcador, minuto y
## si el hecho oculto ya fue revelado por un evento visible — nunca el
## hecho oculto en sí antes de eso (pilar 4: ventaja temporal).
##
## Fórmula deliberadamente simple y legible: un "edge" (ventaja neta local)
## se pasa por una logística para obtener probabilidad, y de ahí a cuota
## decimal con un margen de casa fijo. Nada de aprendizaje adaptativo (D-013).

const MARGIN := 0.93
const SENSITIVITY := 0.32
const MIN_ODDS := 1.10
const MAX_ODDS := 12.0

static func compute_home_odds(sim: MatchSimulator) -> float:
	var home_stats := TeamStats.get_team(sim.home_team_id())
	var away_stats := TeamStats.get_team(sim.away_team_id())

	var edge: float = (float(home_stats.get("attack", 5.0)) + float(home_stats.get("defense", 5.0))) \
		- (float(away_stats.get("attack", 5.0)) + float(away_stats.get("defense", 5.0)))

	if home_stats.get("home_advantage", false):
		edge += 1.5
	if away_stats.get("home_advantage", false):
		edge -= 0.5

	var fact := sim.fact_status()
	if fact.get("revealed", false):
		var penalty: float = float(fact.get("penalty", 0.0)) * 10.0
		if fact.get("affected_team", "") == sim.home_team_id():
			edge -= penalty
		elif fact.get("affected_team", "") == sim.away_team_id():
			edge += penalty

	var score_diff := sim.home_score - sim.away_score
	var minutes_played_ratio := clampf(float(sim.minute) / float(MatchSimulator.MATCH_LENGTH_MINUTES), 0.0, 1.0)
	edge += float(score_diff) * (2.0 + minutes_played_ratio * 4.0)

	var home_probability := 1.0 / (1.0 + exp(-edge * SENSITIVITY))
	home_probability = clampf(home_probability, 0.06, 0.94)

	var fair_odds := 1.0 / home_probability
	var market_odds := clampf(fair_odds * MARGIN, MIN_ODDS, MAX_ODDS)
	return snappedf(market_odds, 0.01)
