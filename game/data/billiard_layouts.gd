class_name BilliardLayouts
extends RefCounted

## Mesas del modo "Tiro imposible". Tres por nivel de Tino; una serie son las
## tres de su nivel en orden. Bola 0 = blanca, 1 = roja (objetivo salvo que se
## diga otra cosa). Mesa de 900 x 450 (ver BilliardSim). Troneras:
## 0 arriba izq · 1 arriba centro · 2 arriba der · 3 abajo izq · 4 abajo centro · 5 abajo der.
## Cada mesa tiene solución comprobada por tests/billar_test.gd.

const LEVELS := [
	[
		{"name": "Para ir calentando", "solution": [27.0, 0.8], "mission": "Mete la roja en cualquier tronera.",
			"balls": [["cue", 220, 300], ["red", 640, 150]],
			"rules": {"target": 1}},
		{"name": "Al rincón", "solution": [15.25, 0.65], "mission": "Mete la roja en la tronera marcada.",
			"balls": [["cue", 380, 260], ["red", 760, 370]],
			"rules": {"target": 1, "pocket": 5}},
		{"name": "Ni mirarla", "solution": [32.5, 0.8], "mission": "Mete la roja sin tocar la negra.",
			"balls": [["cue", 160, 225], ["red", 720, 140], ["black", 450, 190]],
			"rules": {"target": 1, "forbidden": [2]}},
	],
	[
		{"name": "A una banda", "solution": [34.25, 0.8], "mission": "La blanca toca banda antes que ninguna bola. Luego, roja dentro.",
			"balls": [["cue", 200, 330], ["red", 700, 250]],
			"rules": {"target": 1, "cushion_first": true}},
		{"name": "Carambola de barrio", "solution": [52.75, 0.65], "mission": "Toca primero la azul y mete la roja.",
			"balls": [["cue", 400, 428], ["red", 760, 120], ["blue", 540, 308]],
			"rules": {"target": 1, "first_hit": 2}},
		{"name": "El pasillo", "solution": [17.5, 0.8], "mission": "Mete la roja en la tronera marcada sin tocar las negras.",
			"balls": [["cue", 120, 120], ["red", 760, 330], ["black", 450, 170], ["black", 450, 300]],
			"rules": {"target": 1, "pocket": 5, "forbidden": [2, 3]}},
	],
	[
		{"name": "Detrás del muro", "solution": [29.0, 0.8], "mission": "A banda y sin tocar las negras: roja dentro.",
			"balls": [["cue", 180, 225], ["red", 760, 225], ["black", 470, 160], ["black", 470, 225], ["black", 470, 290]],
			"rules": {"target": 1, "cushion_first": true, "forbidden": [2, 3, 4]}},
		{"name": "La combinada", "solution": [74.0, 0.8], "mission": "Toca primero la verde y mete la roja en la tronera marcada.",
			"balls": [["cue", 572, 281], ["red", 830, 60], ["green", 739, 138]],
			"rules": {"target": 1, "first_hit": 2, "pocket": 2}},
		{"name": "La imposible de Tino", "solution": [23.75, 1.0], "mission": "A banda, roja en la tronera marcada, sin tocar la negra.",
			"balls": [["cue", 450, 380], ["red", 450, 120], ["black", 450, 250]],
			"rules": {"target": 1, "cushion_first": true, "pocket": 1, "forbidden": [2]}},
	],
]

## Devuelve la mesa lista para BilliardSim.setup(). jitter mueve un poco las
## bolas para que no siempre sea idéntica (0 en las pruebas).
static func build(level: int, index: int, jitter: float = 0.0, rng: RandomNumberGenerator = null) -> Dictionary:
	var src: Dictionary = LEVELS[level - 1][index]
	var balls: Array = []
	for b in src["balls"]:
		var p := Vector2(float(b[1]), float(b[2]))
		if jitter > 0.0 and rng != null:
			p += Vector2(rng.randf_range(-jitter, jitter), rng.randf_range(-jitter, jitter))
		balls.append({"kind": b[0], "pos": p})
	return {"name": src["name"], "mission": src["mission"], "balls": balls, "rules": src["rules"], "solution": src["solution"]}
