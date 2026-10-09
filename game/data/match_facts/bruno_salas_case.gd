class_name BrunoSalasCase
extends RefCounted

## Caso de referencia del primer slice (design/CORE_LOOP.md).
## Bruno Salas (McLarens FC) juega desde el inicio: el técnico no mintió
## en rueda de prensa, solo no dijo todo. El periódico y El Cortado dan
## pistas antes de que la casa lo sepa; Verde Siempre resta importancia.

static func create() -> MatchFact:
	return MatchFact.new({
		"affected_team": "mclarens_fc",
		"affected_player": "Bruno Salas",
		"attack_penalty": 0.18,
		"injury_event_bonus": 0.35,
		"active_from_minute": 0,
		"active_until_minute": 30,
	})
