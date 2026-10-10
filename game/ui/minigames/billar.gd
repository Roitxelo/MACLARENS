extends Control

## Billar "Tiro imposible" contra Tino. Una serie son 3 mesas preparadas
## (data/billiard_layouts.gd) con una misión cada una; aciertas 2 y ganas la
## apuesta. Apuntar: ratón (y flechas ← → para afinar). Potencia: mantén el
## clic izquierdo y suelta; clic derecho cancela.

const ORIGIN := Vector2(190, 178)      # esquina superior izquierda del paño
const MINUTES_COST := 20
const BALL_COLORS := {"cue": Color("#f4f1e8"), "red": Color("#c0392b"), "blue": Color("#2e5fa8"), "green": Color("#2f8a3a"), "black": Color("#141414")}

var main: Control
var args: Dictionary
var rival: Dictionary
var level := 1
var shot_index := 0
var made := 0
var missed := 0
var layout: Dictionary = {}
var sim := BilliardSim.new()
var state := "aim"                     # aim, charging, rolling, result, over
var aim := 0.0
var power := 0.0
var charge_t := 0.0
var acc := 0.0
var result_t := 0.0
var last_result: Dictionary = {}
var retry_available := false
var steady := false                    # corazonada: trayectoria completa
var _steady_path: Array = []
var _steady_t := 0.0
var _guide: Array = []                 # [camino de la blanca, camino de la bola tocada, índice]
var _guide_key := Vector2(INF, INF)    # (ángulo, potencia) de la última guía calculada
var _last_power := 0.7
var autoplay := false
var settled := false
var mission_label: Label
var info: Label
var score_label: Label
var luck_btn: Button
var retry_btn: Button
var next_btn: Button
var quit_btn: Button
var end_box: Control

func _ready() -> void:
	rival = args.get("rival", {"id": "tino", "name": "Tino", "stake": 20, "level": 1})
	level = int(rival.get("level", Night.level("tino")))
	autoplay = bool(args.get("autoplay", false))
	retry_available = Night.has_trinket("repeticion")
	Night.set_pause("minigame", true)
	Night.start_billar_series()
	score_label = UIKit.shadow(UIKit.label("", 30, UIKit.GOLD))
	UIKit.place(score_label, Rect2(360, 64, 640, 38))
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(score_label)
	mission_label = UIKit.label("", 19, UIKit.PAPER_INK)
	mission_label.add_theme_stylebox_override("normal", UIKit.box(Color("#efe2c4"), Color("#6b4f30"), 3, 4, 10))
	UIKit.place(mission_label, Rect2(300, 104, 680, 40))
	mission_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mission_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(mission_label)
	var pic := UIKit.texture_rect(UIKit.portrait("tino"), Rect2(1150, 60, 110, 110))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	info = UIKit.shadow(UIKit.label("", 19, UIKit.CREAM))
	UIKit.place(info, Rect2(300, 664, 680, 26))
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(info)
	quit_btn = UIKit.button("RENDIRSE", "wood", 16)
	UIKit.place(quit_btn, Rect2(24, 668, 140, 40))
	quit_btn.tooltip_text = "Pierdes la apuesta y vuelves al bar"
	quit_btn.pressed.connect(func():
		if state != "over":
			made = 0
			_finish())
	add_child(quit_btn)
	retry_btn = UIKit.button("REPETIR TIRO", "gold", 16)
	UIKit.place(retry_btn, Rect2(1000, 668, 130, 40))
	retry_btn.tooltip_text = "Bola de la suerte: repites un tiro fallado por serie"
	retry_btn.visible = false
	retry_btn.pressed.connect(_retry)
	add_child(retry_btn)
	next_btn = UIKit.button("SEGUIR", "wood", 16)
	UIKit.place(next_btn, Rect2(860, 668, 130, 40))
	next_btn.visible = false
	next_btn.pressed.connect(func():
		next_btn.visible = false
		_next())
	add_child(next_btn)
	luck_btn = UIKit.button("CORAZONADA\nPULSO FIRME", "gold", 14)
	UIKit.place(luck_btn, Rect2(1170, 190, 104, 64))
	luck_btn.tooltip_text = "Gasta 1 de suerte: ves el recorrido completo de este tiro"
	luck_btn.pressed.connect(func():
		if state == "aim" and not steady and Night.spend_luck():
			steady = true
			_steady_t = 0.0)
	add_child(luck_btn)
	_load_shot()

func _exit_tree() -> void:
	Night.set_pause("minigame", false)

func _stake() -> int:
	return int(rival["stake"])

func _load_shot() -> void:
	layout = BilliardLayouts.build(level, shot_index)
	sim = BilliardSim.new()
	sim.setup(layout["balls"])
	state = "aim"
	power = 0.0
	steady = false
	_steady_path.clear()
	_guide.clear()
	_guide_key = Vector2(INF, INF)
	var target: Vector2 = sim.pos[1]
	aim = ((target - (sim.pos[0] as Vector2))).angle()
	mission_label.text = "TIRO %d/3 · %s — %s" % [shot_index + 1, layout["name"], layout["mission"]]
	info.text = "Apunta con el ratón y afina con la rueda o ← →. Mantén el clic para cargar y suelta."
	_update_score()

func _update_score() -> void:
	score_label.text = "TINO Nv%d · %d € a %s · ACIERTOS %d  FALLOS %d  (necesitas 2)" % [level, _stake(), Catalog.tino_pay_text(level), made, missed]
	luck_btn.disabled = Night.luck <= 0 or steady or state != "aim"

func _table_mouse() -> Vector2:
	return get_local_mouse_position() - ORIGIN

func _gui_input(event: InputEvent) -> void:
	if autoplay:
		return
	if event is InputEventMouseMotion and state in ["aim", "charging"]:
		var d := _table_mouse() - (sim.pos[0] as Vector2)
		if d.length() > 4.0:
			aim = d.angle()
	elif event is InputEventMouseButton and event.pressed and event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN] and state in ["aim", "charging"]:
		# Rueda: afina sin mover el ratón (0,1°; con el Guante, 0,025°).
		var fine := deg_to_rad(0.025 if Night.has_trinket("guante") else 0.1)
		aim += fine if event.button_index == MOUSE_BUTTON_WHEEL_UP else -fine
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and state == "aim":
		state = "charging"
		charge_t = 0.0
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT and state == "charging":
		_shoot(power)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and state == "charging":
		state = "aim"
		power = 0.0

func _unhandled_key_input(event: InputEvent) -> void:
	if autoplay or not (state in ["aim", "charging"]):
		return
	if event.pressed:
		var k := (event as InputEventKey).keycode
		var step := deg_to_rad(0.05 if Night.has_trinket("guante") else 0.2)
		if k == KEY_LEFT or k == KEY_A:
			aim -= step
		elif k == KEY_RIGHT or k == KEY_D:
			aim += step

func _shoot(p: float) -> void:
	_last_power = maxf(0.08, p)
	sim.shoot(aim, maxf(0.08, p))
	state = "rolling"
	acc = 0.0
	steady = false
	_update_score()

func _retry() -> void:
	retry_available = false
	retry_btn.visible = false
	next_btn.visible = false
	missed -= 1
	_load_shot()

func _process(delta: float) -> void:
	match state:
		"aim":
			if autoplay:
				var sol: Array = layout["solution"]
				aim = deg_to_rad(float(sol[0]) + float(args.get("aim_noise", 0.0)))
				_shoot(float(sol[1]))
			else:
				if steady:
					_steady_t -= delta
					if _steady_t <= 0.0:
						_steady_t = 0.12
						_steady_path = _predict(aim, _last_power)
				_refresh_guide(delta, _last_power)
		"charging":
			charge_t += delta
			var period := 2.6 if Night.has_trinket("taco") else 1.6
			var ph := fmod(charge_t / (period * 0.5), 2.0)
			power = ph if ph < 1.0 else 2.0 - ph
			_refresh_guide(delta, maxf(0.08, power))
		"rolling":
			acc += minf(delta, 0.05) * (4.0 if autoplay else 1.0)
			while acc >= BilliardSim.STEP and sim.moving():
				sim.step()
				acc -= BilliardSim.STEP
			if not sim.moving() or sim.time > 14.0:
				_resolve()
		"result":
			result_t -= delta
			if result_t <= 0.0:
				_next()
	queue_redraw()

func _resolve() -> void:
	last_result = sim.evaluate(layout["rules"])
	if last_result["ok"]:
		made += 1
		info.text = "¡DENTRO! " + ["Tino se atraganta con el puro.", "Hasta Lucía aplaude.", "Tino: \"Suerte de principiante.\""][shot_index % 3]
	else:
		missed += 1
		info.text = "%s Tino: \"%s\"" % [last_result["reason"], ["Te lo dije.", "Imposible es imposible.", "Eso en mi pueblo es falta."][shot_index % 3]]
	state = "result"
	result_t = 2.2 if not autoplay else 0.1
	if not last_result["ok"] and retry_available and not autoplay:
		# Bola de la suerte: el jugador decide si repite o sigue.
		retry_btn.visible = true
		next_btn.visible = true
		result_t = INF
	_update_score()

func _next() -> void:
	retry_btn.visible = false
	next_btn.visible = false
	if made >= 2 or missed >= 2 or shot_index >= 2:
		_finish()
		return
	shot_index += 1
	_load_shot()

func _finish() -> void:
	state = "over"
	if settled:
		return
	settled = true
	var won := made >= 2
	var stake := _stake()
	var gained := 0
	var extra := ""
	if won:
		Night.spend(mini(stake, Night.money))
		gained = Night.register_win("billar", stake, Catalog.tino_gross(level, stake)) - stake
		Night.log_moment("Billar: le ganas la serie a Tino (Nv%d)" % level, gained)
		if level >= 3:
			if not Night.tino_forgave:
				Night.tino_forgave = true
				Night.reduce_debt(100, "Tino te perdona 100 €")
				extra = "Y te rebaja 100 € de la última noche."
		else:
			Night.levels["tino"] = level + 1
			extra = "Tino sube a Nv%d: ahora paga %s." % [level + 1, Catalog.tino_pay_text(level + 1)]
	else:
		Night.spend(mini(stake, Night.money))
		Night.register_loss("billar")
		Night.log_moment("Billar: Tino gana la serie", -stake)
	Night.set_pause("minigame", false)
	Night.advance(MINUTES_COST)
	luck_btn.visible = false
	retry_btn.visible = false
	next_btn.visible = false
	quit_btn.visible = false
	end_box = Control.new()
	end_box.size = size
	add_child(end_box)
	UIKit.panel(end_box, Rect2(390, 250, 500, 230), Color("#2a1a10"), UIKit.GOLD, 3)
	var t := UIKit.label("¡SERIE GANADA! +%d €" % gained if won else "TINO GANA · -%d €" % stake, 34, Color("#9ff59a") if won else Color("#ff9b8a"))
	UIKit.place(t, Rect2(390, 270, 500, 44))
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_box.add_child(t)
	var q := UIKit.label("Tino: \"%s\" %s" % ["Vale, vale. Hoy tienes el pulso fino." if won else "Vuelve cuando aprendas a coger el taco.", extra], 19, UIKit.CREAM)
	UIKit.place(q, Rect2(410, 320, 460, 64))
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_box.add_child(q)
	var back := UIKit.button("VOLVER AL SALÓN", "wood", 20)
	UIKit.place(back, Rect2(420, 400, 210, 50))
	back.pressed.connect(func(): main.go("salon"))
	end_box.add_child(back)
	var again := UIKit.button("OTRA SERIE", "red", 20)
	UIKit.place(again, Rect2(650, 400, 210, 50))
	again.disabled = Night.minutes_left() < MINUTES_COST or Night.over or Night.billar_left() <= 0
	if Night.billar_left() <= 0:
		again.text = "TINO SE RETIRA"
	again.pressed.connect(func(): main.go("billar_lobby"))
	end_box.add_child(again)
	Night.check_broke()

# --- Guías de tiro --------------------------------------------------------------

## Primer contacto en línea recta desde la blanca: {point, ball (-1 = banda), normal}.
func _first_contact(from: Vector2, dir: Vector2) -> Dictionary:
	var best_t := INF
	var best := {"ball": -1, "point": from}
	for i in range(1, sim.pos.size()):
		if not sim.alive[i]:
			continue
		var c: Vector2 = sim.pos[i]
		var m := c - from
		var tca := m.dot(dir)
		if tca <= 0.0:
			continue
		var d2 := m.length_squared() - tca * tca
		var rr := 4.0 * BilliardSim.R * BilliardSim.R
		if d2 > rr:
			continue
		var t := tca - sqrt(rr - d2)
		if t < best_t:
			best_t = t
			best = {"ball": i, "point": from + dir * t}
	# banda
	var tx := INF
	if dir.x > 0.0001: tx = (BilliardSim.W - BilliardSim.R - from.x) / dir.x
	elif dir.x < -0.0001: tx = (BilliardSim.R - from.x) / dir.x
	var ty := INF
	if dir.y > 0.0001: ty = (BilliardSim.H - BilliardSim.R - from.y) / dir.y
	elif dir.y < -0.0001: ty = (BilliardSim.R - from.y) / dir.y
	var tw := minf(tx, ty)
	if tw < best_t:
		return {"ball": -1, "point": from + dir * tw, "normal": Vector2(-signf(dir.x), 0) if tx < ty else Vector2(0, -signf(dir.y))}
	return best

## Guía corta de base (C06, review 03: "demasiado fácil"): la blanca hasta su
## primer choque (bola o banda) y solo la salida de la bola tocada. La Tiza
## suma un rebote y sigue más a la bola tocada; la corazonada enseña todo.
const GUIDE_BASE_EVENTS := 1
const GUIDE_BASE_OBJECT := 60.0
const GUIDE_TIZA_EVENTS := 1
const GUIDE_TIZA_OBJECT := 200.0

func guide_events() -> int:
	return GUIDE_BASE_EVENTS + (GUIDE_TIZA_EVENTS if Night.has_trinket("tiza") else 0)

func guide_object_length() -> float:
	return GUIDE_BASE_OBJECT + (GUIDE_TIZA_OBJECT if Night.has_trinket("tiza") else 0.0)

## Se recalcula en el mismo frame en que cambian el ángulo o la potencia.
func _refresh_guide(_delta: float, p: float) -> void:
	var key := Vector2(aim, p)
	if key.distance_to(_guide_key) < 0.00005:
		return
	_guide_key = key
	_guide = guide_paths(aim, p)

## Guía tipo móvil: el recorrido real (misma física que el tiro) de la blanca
## hasta `guide_events()` rebotes o choques, y el de la primera bola que mueve,
## recortado a `guide_object_length()` píxeles.
func guide_paths(angle: float, p: float) -> Array:
	var copy := BilliardSim.new()
	var balls: Array = []
	for i in sim.pos.size():
		balls.append({"kind": sim.kinds[i], "pos": sim.pos[i]})
	copy.setup(balls)
	copy.shoot(angle, p)
	var cue := PackedVector2Array([copy.pos[0]])
	var obj := PackedVector2Array()
	var obj_i := -1
	var obj_len := 0.0
	var obj_max := guide_object_length()
	var max_ev := guide_events()
	var events := 0
	var prev_dir := Vector2.from_angle(angle)
	var cue_done := false
	var steps := 0
	while copy.moving() and copy.time < 8.0:
		copy.step()
		steps += 1
		if not cue_done:
			var v: Vector2 = copy.vel[0]
			if not copy.alive[0] or v.length() < 1.0:
				cue.append(copy.pos[0])
				cue_done = true
			else:
				var d := v.normalized()
				if d.dot(prev_dir) < 0.985:
					events += 1
					cue.append(copy.pos[0])
					cue_done = events >= max_ev
				elif steps % 4 == 0:
					cue.append(copy.pos[0])
				prev_dir = d
		if obj_i < 0:
			for i in range(1, copy.pos.size()):
				if copy.alive[i] and (copy.vel[i] as Vector2).length() > 1.0:
					obj_i = i
					obj.append(copy.pos[i])
					break
		elif obj_len < obj_max and steps % 4 == 0:
			var cur: Vector2 = copy.pos[obj_i]
			obj_len += obj[obj.size() - 1].distance_to(cur)
			obj.append(cur)
			if not copy.alive[obj_i]:
				obj_len = obj_max
		# Se para en cuanto la guía tiene lo que va a enseñar (review 04: iba a
		# saltos). Si la blanca acabó sin mover ninguna bola, no hay más que ver.
		if cue_done and (obj_i < 0 or obj_len >= obj_max):
			break
	return [cue, obj, obj_i]

func _predict(angle: float, p: float) -> Array:
	var copy := BilliardSim.new()
	var balls: Array = []
	for i in sim.pos.size():
		balls.append({"kind": sim.kinds[i], "pos": sim.pos[i]})
	copy.setup(balls)
	copy.shoot(angle, p)
	var paths: Array = []
	for i in balls.size():
		paths.append(PackedVector2Array([copy.pos[i]]))
	var n := 0
	while copy.moving() and copy.time < 8.0:
		copy.step()
		n += 1
		if n % 6 == 0:
			for i in balls.size():
				if copy.alive[i] and (copy.vel[i] as Vector2).length() > 1.0:
					paths[i].append(copy.pos[i])
	return paths

# --- Dibujo ---------------------------------------------------------------------------

## Línea de puntos (estilo guía de móvil) con un círculo al final.
func _draw_path(path: PackedVector2Array, col: Color) -> void:
	if path.size() < 2:
		return
	var carry := 0.0
	for k in range(1, path.size()):
		var a: Vector2 = ORIGIN + path[k - 1]
		var b: Vector2 = ORIGIN + path[k]
		var seg := a.distance_to(b)
		var t := carry
		while t < seg:
			draw_circle(a.lerp(b, t / seg), 2.0, col)
			t += 9.0
		carry = t - seg
	draw_arc(ORIGIN + path[path.size() - 1], 5.0, 0, TAU, 16, col, 2.0)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#1c110a"))
	var w := BilliardSim.W
	var h := BilliardSim.H
	draw_rect(Rect2(ORIGIN - Vector2(34, 34), Vector2(w + 68, h + 68)), Color("#4a2a16"))
	draw_rect(Rect2(ORIGIN - Vector2(22, 22), Vector2(w + 44, h + 44)), Color("#1f5a34"))
	draw_rect(Rect2(ORIGIN, Vector2(w, h)), Color("#2a7a45"))
	for k in BilliardSim.POCKETS.size():
		var pc: Vector2 = ORIGIN + BilliardSim.POCKETS[k]
		draw_circle(pc, BilliardSim.POCKET_R - 4, Color("#0b0b0b"))
		if not layout.is_empty() and int(layout["rules"].get("pocket", -1)) == k:
			draw_arc(pc, BilliardSim.POCKET_R + 2, 0, TAU, 32, UIKit.GOLD, 4.0)
	for dx in [0.25, 0.5, 0.75]:
		draw_circle(ORIGIN + Vector2(w * dx, -27), 3, Color("#d8c8a8"))
		draw_circle(ORIGIN + Vector2(w * dx, h + 27), 3, Color("#d8c8a8"))
	# guía
	if state in ["aim", "charging"] and not sim.pos.is_empty():
		var cue: Vector2 = sim.pos[0]
		var dir := Vector2.from_angle(aim)
		var c := _first_contact(cue, dir)
		if int(c["ball"]) >= 0:
			draw_arc(ORIGIN + (c["point"] as Vector2), BilliardSim.R, 0, TAU, 24, Color(1, 1, 1, 0.6), 1.5)
		if _guide.size() == 3:
			_draw_path(_guide[0], Color(1, 1, 1, 0.7))
			var oi: int = _guide[2]
			if oi >= 0:
				_draw_path(_guide[1], (BALL_COLORS.get(sim.kinds[oi], Color.WHITE) as Color).lightened(0.35))
		if steady:
			for i in _steady_path.size():
				var path: PackedVector2Array = _steady_path[i]
				if path.size() > 1:
					var pts := PackedVector2Array()
					for p in path:
						pts.append(ORIGIN + p)
					draw_polyline(pts, Color(1, 0.85, 0.4, 0.8) if i == 0 else Color(1, 0.5, 0.4, 0.8), 2.0)
		# taco
		var back := 30.0 + power * 70.0
		draw_line(ORIGIN + cue - dir * back, ORIGIN + cue - dir * (back + 260.0), Color("#c9a26a"), 7.0)
		draw_line(ORIGIN + cue - dir * back, ORIGIN + cue - dir * (back + 12.0), Color("#2b5cad"), 7.0)
		# barra de potencia
		var bar := Rect2(ORIGIN.x + w + 46, ORIGIN.y + 40, 22, h - 80)
		draw_rect(bar.grow(3), Color.BLACK)
		draw_rect(bar, Color("#3b2416"))
		var fill := bar.size.y * power
		draw_rect(Rect2(bar.position.x, bar.end.y - fill, bar.size.x, fill), Color("#c94b3b").lerp(Color("#f0bd54"), power))
		draw_string(UIKit.FONT_UI, Vector2(bar.position.x - 14, bar.end.y + 26), "%d%%" % int(power * 100), HORIZONTAL_ALIGNMENT_LEFT, -1, 18, UIKit.CREAM)
		draw_string(UIKit.FONT_SCREEN, Vector2(ORIGIN.x, ORIGIN.y + h + 52), "%.1f°" % fposmod(rad_to_deg(aim), 360.0), HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("#d8e8d0"))
	# bolas
	var forbidden: Array = layout.get("rules", {}).get("forbidden", [])
	for i in sim.pos.size():
		if not sim.alive[i]:
			continue
		var p: Vector2 = ORIGIN + (sim.pos[i] as Vector2)
		draw_circle(p + Vector2(2, 3), BilliardSim.R, Color(0, 0, 0, 0.35))
		draw_circle(p, BilliardSim.R, BALL_COLORS.get(sim.kinds[i], Color.WHITE))
		draw_circle(p + Vector2(-3, -3), 3, Color(1, 1, 1, 0.55))
		if forbidden.has(i):
			draw_arc(p, BilliardSim.R + 4, 0, TAU, 20, Color("#ff5a4a"), 2.0)
		if i == int(layout.get("rules", {}).get("target", 1)):
			draw_arc(p, BilliardSim.R + 4, 0, TAU, 20, UIKit.GOLD, 2.0)
