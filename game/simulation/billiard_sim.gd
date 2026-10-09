class_name BilliardSim
extends RefCounted

## Física de billar 2D, determinista y sin dependencias de nodos: la usan el
## minijuego (ui/minigames/billar.gd) y el buscador de soluciones de las
## pruebas (tests/billar_test.gd). Coordenadas en píxeles de mesa (0..W, 0..H).
## La bola 0 es siempre la blanca.

const W := 900.0
const H := 450.0
const R := 11.0
const POCKET_R := 30.0
const MAX_SPEED := 1500.0
const ROLL_DECEL := 230.0        # px/s² de frenado por rodadura
const DAMP := 0.25               # frenado proporcional a la velocidad (1/s)
const BALL_E := 0.95             # restitución bola-bola
const CUSHION_E := 0.78          # restitución contra la banda
const STEP := 1.0 / 240.0
const POCKETS := [
	Vector2(0, 0), Vector2(W * 0.5, -2.0), Vector2(W, 0),
	Vector2(0, H), Vector2(W * 0.5, H + 2.0), Vector2(W, H),
]
const POCKET_NAMES := ["arriba izquierda", "arriba centro", "arriba derecha", "abajo izquierda", "abajo centro", "abajo derecha"]

var pos: Array = []      # Vector2
var vel: Array = []      # Vector2
var alive: Array = []    # bool
var kinds: Array = []    # "cue", "red", "blue", "green", "black"
var events: Array = []   # {t: "hit"|"cushion"|"pocket", a, b, pocket}
var time := 0.0
var _touching := {}      # pares en contacto (para registrar solo el primer toque)

func setup(balls: Array) -> void:
	pos.clear(); vel.clear(); alive.clear(); kinds.clear(); events.clear()
	time = 0.0
	_touching.clear()
	for b in balls:
		pos.append(b["pos"])
		vel.append(Vector2.ZERO)
		alive.append(true)
		kinds.append(b["kind"])

func shoot(angle: float, power: float) -> void:
	vel[0] = Vector2.from_angle(angle) * clampf(power, 0.0, 1.0) * MAX_SPEED

func moving() -> bool:
	for i in pos.size():
		if alive[i] and (vel[i] as Vector2).length_squared() > 1.0:
			return true
	return false

func step(dt: float = STEP) -> void:
	time += dt
	var n := pos.size()
	for i in n:
		if not alive[i]:
			continue
		var v: Vector2 = vel[i]
		var sp := v.length()
		if sp > 0.0:
			var new_sp := maxf(0.0, sp - (ROLL_DECEL + DAMP * sp) * dt)
			v = v * (new_sp / sp) if new_sp > 2.0 else Vector2.ZERO
		vel[i] = v
		pos[i] = (pos[i] as Vector2) + v * dt
	# choques entre bolas
	for i in n:
		if not alive[i]:
			continue
		for j in range(i + 1, n):
			if not alive[j]:
				continue
			var d: Vector2 = (pos[j] as Vector2) - (pos[i] as Vector2)
			var dist := d.length()
			var key := i * 100 + j
			if dist < 2.0 * R and dist > 0.0001:
				var nrm := d / dist
				var rel: float = ((vel[i] as Vector2) - (vel[j] as Vector2)).dot(nrm)
				if rel > 0.0:
					var imp := nrm * rel * (1.0 + BALL_E) * 0.5
					vel[i] = (vel[i] as Vector2) - imp
					vel[j] = (vel[j] as Vector2) + imp
				var overlap := 2.0 * R - dist
				pos[i] = (pos[i] as Vector2) - nrm * overlap * 0.5
				pos[j] = (pos[j] as Vector2) + nrm * overlap * 0.5
				if not _touching.has(key):
					_touching[key] = true
					events.append({"t": "hit", "a": i, "b": j})
			elif dist >= 2.0 * R + 0.5:
				_touching.erase(key)
	# troneras y bandas
	for i in n:
		if not alive[i]:
			continue
		var p: Vector2 = pos[i]
		var pocketed := -1
		for k in POCKETS.size():
			if p.distance_to(POCKETS[k]) < POCKET_R:
				pocketed = k
				break
		if pocketed >= 0:
			alive[i] = false
			vel[i] = Vector2.ZERO
			events.append({"t": "pocket", "a": i, "pocket": pocketed})
			continue
		var v: Vector2 = vel[i]
		var hit := false
		if p.x < R:
			p.x = R; v.x = absf(v.x) * CUSHION_E; hit = true
		elif p.x > W - R:
			p.x = W - R; v.x = -absf(v.x) * CUSHION_E; hit = true
		if p.y < R:
			p.y = R; v.y = absf(v.y) * CUSHION_E; hit = true
		elif p.y > H - R:
			p.y = H - R; v.y = -absf(v.y) * CUSHION_E; hit = true
		if hit:
			events.append({"t": "cushion", "a": i})
		pos[i] = p
		vel[i] = v

func run_to_rest(max_time: float = 14.0) -> void:
	while moving() and time < max_time:
		step()

## Comprueba la misión de una mesa. rules: {target, pocket(-1 = cualquiera),
## first_hit(-1 = cualquiera), cushion_first, forbidden: [índices]}.
func evaluate(rules: Dictionary) -> Dictionary:
	var target: int = rules.get("target", 1)
	var forbidden: Array = rules.get("forbidden", [])
	var first_contact := -1
	var cushion_before := false
	var target_pocket := -1
	for e in events:
		match e["t"]:
			"hit":
				var a: int = e["a"]
				var b: int = e["b"]
				if forbidden.has(a) or forbidden.has(b):
					return {"ok": false, "reason": "Has tocado la %s." % _kind_name(b if forbidden.has(b) else a)}
				if first_contact < 0 and (a == 0 or b == 0):
					first_contact = b if a == 0 else a
			"cushion":
				if e["a"] == 0 and first_contact < 0:
					cushion_before = true
			"pocket":
				if e["a"] == 0:
					return {"ok": false, "reason": "¡La blanca se ha colado!"}
				if e["a"] == target and target_pocket < 0:
					target_pocket = e["pocket"]
				elif forbidden.has(e["a"]):
					return {"ok": false, "reason": "Has metido la %s." % _kind_name(e["a"])}
	if first_contact < 0:
		return {"ok": false, "reason": "La blanca no ha tocado ninguna bola."}
	var fh: int = rules.get("first_hit", -1)
	if fh >= 0 and first_contact != fh:
		return {"ok": false, "reason": "Tenías que tocar primero la %s." % _kind_name(fh)}
	if rules.get("cushion_first", false) and not cushion_before:
		return {"ok": false, "reason": "La blanca tenía que tocar banda antes."}
	if target_pocket < 0:
		return {"ok": false, "reason": "La %s no ha entrado." % _kind_name(target)}
	var need: int = rules.get("pocket", -1)
	if need >= 0 and target_pocket != need:
		return {"ok": false, "reason": "Ha entrado, pero no en la tronera marcada."}
	return {"ok": true, "reason": "¡Dentro!"}

func _kind_name(i: int) -> String:
	match kinds[i]:
		"red": return "roja"
		"blue": return "azul"
		"green": return "verde"
		"black": return "negra"
	return "blanca"
