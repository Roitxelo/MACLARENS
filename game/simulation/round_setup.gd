class_name RoundSetup
extends RefCounted

## Punto de entrada único de C2 para la UI (game/ui/): crea las dos
## simulaciones reproducibles del primer slice, ya cableadas con el caso
## Bruno Salas (design/CORE_LOOP.md). Reemplaza a _advance_placeholder_matches
## en game/ui/main_bar.gd — esa sustitución la hace Codex, no este archivo.
##
## Uso previsto desde la UI:
##   var round := RoundSetup.create_default_round()
##   var match_a: MatchSimulator = round["match_a"]   # TV1: McLarens FC vs Atlético Resaca
##   var match_b: MatchSimulator = round["match_b"]   # TV2: Sporting Carbón vs Dinamo Rotonda
##   # en cada tick del reloj de juego:
##   match_a.advance_interval()
##   match_b.advance_interval()
##   var snapshot_a := match_a.snapshot()  # -> MatchSnapshot.new(snapshot_a)

static func create_default_round(seed_value: int = 20260721) -> Dictionary:
	var bruno_fact := BrunoSalasCase.create()

	var match_a := MatchSimulator.new({
		"id": "match_a",
		"home_id": "mclarens_fc",
		"away_id": "atletico_resaca",
		"seed": seed_value,
		"match_fact": bruno_fact,
	})

	var match_b := MatchSimulator.new({
		"id": "match_b",
		"home_id": "sporting_carbon",
		"away_id": "dinamo_rotonda",
		"seed": seed_value + 1,
	})

	return {"match_a": match_a, "match_b": match_b}
