extends SceneTree

## Prueba manual de C2. No hay ejecutable de Godot disponible en este
## entorno (mismo bloqueo que T3 en coordination/TASK_BOARD.md), así que
## esto no se ha podido ejecutar todavía. Cuando haya Godot a mano:
##
##   godot --headless --script game/simulation/tests/manual_trace.gd
##
## Comprueba: (1) los dos partidos avanzan de forma independiente,
## (2) la cuota cambia con marcador/minuto, (3) la misma semilla produce
## la misma secuencia exacta, (4) la cuota de McLarens FC no se mueve por
## la molestia de Bruno hasta que un evento de lesión la revela.

func _init() -> void:
	print("=== Ronda A (semilla 1), 10 intervalos ===")
	var round_1 := RoundSetup.create_default_round(1)
	var match_a: MatchSimulator = round_1["match_a"]
	var match_b: MatchSimulator = round_1["match_b"]
	for i in range(10):
		var event_a := match_a.advance_interval()
		var event_b := match_b.advance_interval()
		print("Tick %d | A: %s | B: %s" % [i, event_a["text"], event_b["text"]])
		print("   Snapshot A: %s" % [match_a.snapshot()])

	print("\n=== Repetición con la misma semilla (debe ser idéntica) ===")
	var round_2 := RoundSetup.create_default_round(1)
	var match_a2: MatchSimulator = round_2["match_a"]
	for i in range(10):
		match_a2.advance_interval()

	var snap_1 := match_a.snapshot()
	var snap_2 := match_a2.snapshot()
	print("Snapshot original:  %s" % [snap_1])
	print("Snapshot repetido:  %s" % [snap_2])
	print("¿Coinciden? -> %s" % [snap_1 == snap_2])

	print("\n=== Semilla distinta (debe poder divergir) ===")
	var round_3 := RoundSetup.create_default_round(2)
	var match_a3: MatchSimulator = round_3["match_a"]
	for i in range(10):
		match_a3.advance_interval()
	print("Snapshot semilla 2: %s" % [match_a3.snapshot()])

	quit()
