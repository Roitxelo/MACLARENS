class_name TeamStats
extends RefCounted

## Datos base de los equipos ficticios de la jam (doc. 01, sección 5.1).
## Solo datos: la lógica de simulación vive en game/simulation/, no aquí.
## Ampliar esta tabla no debe requerir tocar el motor.

const TEAMS := {
	"mclarens_fc": {
		"display_name": "McLarens FC",
		"attack": 6.0,
		"defense": 5.0,
		"form": 6.0,
		"discipline": 5.0,
		"home_advantage": true,
	},
	"atletico_resaca": {
		"display_name": "Atlético Resaca",
		"attack": 5.0,
		"defense": 6.0,
		"form": 5.0,
		"discipline": 6.0,
		"home_advantage": false,
	},
	"sporting_carbon": {
		"display_name": "Sporting Carbón",
		"attack": 6.0,
		"defense": 4.0,
		"form": 7.0,
		"discipline": 4.0,
		"home_advantage": true,
	},
	"dinamo_rotonda": {
		"display_name": "Dinamo Rotonda",
		"attack": 4.0,
		"defense": 7.0,
		"form": 4.0,
		"discipline": 7.0,
		"home_advantage": false,
	},
}

static func get_team(id: String) -> Dictionary:
	return TEAMS.get(id, {
		"display_name": id,
		"attack": 5.0,
		"defense": 5.0,
		"form": 5.0,
		"discipline": 5.0,
		"home_advantage": false,
	})
