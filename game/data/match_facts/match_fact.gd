class_name MatchFact
extends RefCounted

## Hecho oculto que la simulación conoce desde el minuto 0 pero que la casa
## no incorpora a la cuota hasta que un evento visible lo confirma en la
## retransmisión. Ver design/CORE_LOOP.md, sección "Caso de referencia".
##
## Un MatchFact nunca fuerza un resultado: solo sesga pesos de eventos y,
## una vez revelado, sesga la cuota. Pilar 3 (probabilidades dinámicas).

var affected_team: String
var affected_player: String
var attack_penalty: float      # 0.0-1.0: reduce el ataque efectivo del equipo mientras está activo
var injury_event_bonus: float  # 0.0-1.0: suma peso extra al evento "lesión" de ese equipo
var active_from_minute: int
var active_until_minute: int
var revealed: bool = false     # true en cuanto el evento visible lo confirma en simulación

func _init(data: Dictionary) -> void:
	affected_team = str(data.get("affected_team", ""))
	affected_player = str(data.get("affected_player", ""))
	attack_penalty = clampf(float(data.get("attack_penalty", 0.0)), 0.0, 1.0)
	injury_event_bonus = clampf(float(data.get("injury_event_bonus", 0.0)), 0.0, 1.0)
	active_from_minute = int(data.get("active_from_minute", 0))
	active_until_minute = int(data.get("active_until_minute", 90))

func is_active(minute: int) -> bool:
	return minute >= active_from_minute and minute <= active_until_minute
