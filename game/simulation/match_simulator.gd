class_name MatchSimulator
extends RefCounted

## Simula un partido de fútbol por intervalos discretos (doc. 01, sección 6).
## Produce eventos reproducibles (semilla fija) y expone un snapshot
## compatible con game/contracts/match_snapshot.gd.
##
## No decide el resultado de antemano: cada intervalo pondera pesos de
## evento a partir de estadísticas públicas de equipo y, si existe, un
## MatchFact oculto (game/data/match_facts/). El hecho oculto nunca se
## expone directamente; solo se sabe que existió cuando dispara un evento
## visible (ver fact_status()).

const MINUTES_PER_TICK := 3
const MATCH_LENGTH_MINUTES := 90

enum EventType {
	NONE,
	GOAL_HOME,
	GOAL_AWAY,
	CARD_HOME,
	CARD_AWAY,
	INJURY_HOME,
	INJURY_AWAY,
	CORNER_HOME,
	CORNER_AWAY,
}

var id: String
var home_id: String
var away_id: String
var home_score := 0
var away_score := 0
var home_cards := 0
var away_cards := 0
var minute := 0
var finished := false
var last_event_type: int = EventType.NONE
var last_event_text: String = "Calentamiento"

var _home_stats: Dictionary
var _away_stats: Dictionary
var _match_fact: MatchFact
var _fatigue_home := 0.0
var _fatigue_away := 0.0
var _rng := RandomNumberGenerator.new()

func _init(config: Dictionary) -> void:
	id = str(config.get("id", "match"))
	home_id = str(config.get("home_id", ""))
	away_id = str(config.get("away_id", ""))
	_home_stats = TeamStats.get_team(home_id)
	_away_stats = TeamStats.get_team(away_id)
	_match_fact = config.get("match_fact", null) as MatchFact
	_rng.seed = int(config.get("seed", 0))

func home_team_id() -> String:
	return home_id

func away_team_id() -> String:
	return away_id

## Estado público del hecho oculto: solo es útil para la casa/UI una vez revelado.
func fact_status() -> Dictionary:
	if _match_fact == null:
		return {"revealed": false}
	return {
		"revealed": _match_fact.revealed,
		"affected_team": _match_fact.affected_team,
		"affected_player": _match_fact.affected_player,
		"penalty": _match_fact.attack_penalty,
	}

func advance_interval() -> Dictionary:
	if finished:
		return _event_result(EventType.NONE, "El partido ya terminó.")

	minute = mini(minute + MINUTES_PER_TICK, MATCH_LENGTH_MINUTES)
	_fatigue_home = minf(_fatigue_home + 0.01, 0.35)
	_fatigue_away = minf(_fatigue_away + 0.01, 0.35)

	var weights := _build_event_weights()
	var event_type := _roll_event(weights)
	var result := _apply_event(event_type)

	if minute >= MATCH_LENGTH_MINUTES:
		finished = true

	return result

func snapshot() -> Dictionary:
	return {
		"id": id,
		"home": _display(home_id),
		"away": _display(away_id),
		"home_score": home_score,
		"away_score": away_score,
		"minute": minute,
		"home_odds": OddsEngine.compute_home_odds(self),
		"last_event": last_event_text,
	}

func _build_event_weights() -> Dictionary:
	var home_attack_penalty := 0.0
	var away_attack_penalty := 0.0
	var injury_bonus_home := 0.0
	var injury_bonus_away := 0.0

	if _match_fact != null and _match_fact.is_active(minute):
		if _match_fact.affected_team == home_id:
			home_attack_penalty = _match_fact.attack_penalty
			injury_bonus_home = _match_fact.injury_event_bonus
		elif _match_fact.affected_team == away_id:
			away_attack_penalty = _match_fact.attack_penalty
			injury_bonus_away = _match_fact.injury_event_bonus

	var home_attack: float = float(_home_stats.get("attack", 5.0)) * (1.0 - home_attack_penalty) * (1.0 - _fatigue_home)
	var away_attack: float = float(_away_stats.get("attack", 5.0)) * (1.0 - away_attack_penalty) * (1.0 - _fatigue_away)
	var home_defense: float = float(_home_stats.get("defense", 5.0))
	var away_defense: float = float(_away_stats.get("defense", 5.0))
	var home_discipline: float = float(_home_stats.get("discipline", 5.0))
	var away_discipline: float = float(_away_stats.get("discipline", 5.0))
	var home_bonus: float = 1.15 if _home_stats.get("home_advantage", false) else 1.0

	return {
		EventType.NONE: 55.0,
		EventType.GOAL_HOME: maxf(0.5, home_attack - away_defense * 0.4) * home_bonus,
		EventType.GOAL_AWAY: maxf(0.5, away_attack - home_defense * 0.4),
		EventType.CARD_HOME: maxf(0.2, 10.0 - home_discipline),
		EventType.CARD_AWAY: maxf(0.2, 10.0 - away_discipline),
		EventType.INJURY_HOME: 1.5 + injury_bonus_home * 10.0,
		EventType.INJURY_AWAY: 1.5 + injury_bonus_away * 10.0,
		EventType.CORNER_HOME: home_attack * 0.6,
		EventType.CORNER_AWAY: away_attack * 0.6,
	}

func _roll_event(weights: Dictionary) -> int:
	var total := 0.0
	for w in weights.values():
		total += w
	if total <= 0.0:
		return EventType.NONE
	var roll := _rng.randf() * total
	var cumulative := 0.0
	for event_type in weights.keys():
		cumulative += weights[event_type]
		if roll <= cumulative:
			return event_type
	return EventType.NONE

func _apply_event(event_type: int) -> Dictionary:
	last_event_type = event_type
	match event_type:
		EventType.GOAL_HOME:
			home_score += 1
			last_event_text = "¡Gol de %s!" % _display(home_id)
		EventType.GOAL_AWAY:
			away_score += 1
			last_event_text = "¡Gol de %s!" % _display(away_id)
		EventType.CARD_HOME:
			home_cards += 1
			last_event_text = "Tarjeta para %s" % _display(home_id)
		EventType.CARD_AWAY:
			away_cards += 1
			last_event_text = "Tarjeta para %s" % _display(away_id)
		EventType.INJURY_HOME:
			last_event_text = _injury_text(home_id)
		EventType.INJURY_AWAY:
			last_event_text = _injury_text(away_id)
		EventType.CORNER_HOME:
			last_event_text = "Córner para %s" % _display(home_id)
		EventType.CORNER_AWAY:
			last_event_text = "Córner para %s" % _display(away_id)
		_:
			last_event_text = "Minuto %d, sin novedad" % minute
	return _event_result(event_type, last_event_text)

func _injury_text(team_id: String) -> String:
	if _match_fact != null and _match_fact.affected_team == team_id and _match_fact.is_active(minute):
		_match_fact.revealed = true
		return "%s se resiente y pide asistencia" % _match_fact.affected_player
	return "Aviso médico en %s" % _display(team_id)

func _display(team_id: String) -> String:
	if team_id == home_id:
		return str(_home_stats.get("display_name", home_id))
	return str(_away_stats.get("display_name", away_id))

func _event_result(event_type: int, text: String) -> Dictionary:
	return {
		"event_type": event_type,
		"text": text,
		"minute": minute,
		"revealed_fact": _match_fact != null and _match_fact.revealed,
	}
