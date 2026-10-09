extends Control

## Futbolín contra un parroquiano. El jugador mueve todas sus barras con el
## ratón (eje vertical) y chuta fuerte con clic. A 3 goles.

const FIELD := Rect2(150, 150, 980, 450)
const GOAL_HALF := 96.0
const BALL_R := 10.0
const MAN_R := 15.0
const WIN_GOALS := 3
const MINUTES_COST := 20
const KICK_TIME := 0.2

var main: Control
var args: Dictionary
var rival: Dictionary
var skill := 0.5

# Barras: x relativa, número de muñecos, lado (0 = jugador, 1 = rival)
var rods: Array = [
	{"x": 0.05, "n": 1, "side": 0}, {"x": 0.20, "n": 2, "side": 0},
	{"x": 0.36, "n": 3, "side": 1}, {"x": 0.64, "n": 3, "side": 0},
	{"x": 0.80, "n": 2, "side": 1}, {"x": 0.95, "n": 1, "side": 1},
]
var ball := Vector2.ZERO
var vel := Vector2.ZERO
var score := [0, 0]
var state := "intro"           # intro, play, goal, over
var timer := 0.0
var kick_timer := 0.0
var slow_timer := 0.0
var distract_timer := 0.0
var ai_think := 0.0
var ai_freeze := 0.0           # reacción tardía del rival tras un chut
var player_skill := 0.55       # solo para autoplay
var rng := RandomNumberGenerator.new()
var info: Label
var score_label: Label
var hunch_btn: Button
var end_box: Control
var settled := false
var time_left := 100.0        # segundos reales de partida
var autoplay := false          # pruebas: el jugador también lo controla la IA

func _ready() -> void:
	rival = args.get("rival", {"id": "cortado", "name": "El Cortado", "stake": 20, "skill": 0.3})
	skill = float(rival["skill"])
	autoplay = bool(args.get("autoplay", false))
	rng.randomize()
	Night.set_pause("minigame", true)
	for r in rods:
		r["offset"] = 0.0
		r["target"] = 0.0
		r["vel"] = 0.0
	score_label = UIKit.shadow(UIKit.label("", 40, UIKit.GOLD, true))
	UIKit.place(score_label, Rect2(340, 70, 600, 50))
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(score_label)
	var pic := UIKit.texture_rect(UIKit.portrait(rival["id"]), Rect2(1150, 60, 110, 110))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	info = UIKit.shadow(UIKit.label("", 20, UIKit.CREAM))
	UIKit.place(info, Rect2(240, 622, 800, 30))
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(info)
	hunch_btn = UIKit.button("CORAZONADA: CÁMARA LENTA", "gold", 16)
	UIKit.place(hunch_btn, Rect2(1000, 660, 260, 44))
	hunch_btn.tooltip_text = "Gasta 1 de suerte: 6 segundos de cámara lenta (tus barras van a velocidad normal)"
	hunch_btn.pressed.connect(_use_hunch)
	add_child(hunch_btn)
	hunch_btn.disabled = Night.luck <= 0
	info.text = "%s: \"%s\"" % [rival["name"], "Venga, a ver qué sabes hacer."]
	_update_score()
	state = "intro"
	timer = 1.2

var focus_timer := 0.0

func _use_hunch() -> void:
	if state != "play" or not Night.spend_luck():
		return
	focus_timer = 6.0
	hunch_btn.disabled = true
	info.text = "Concentración total: todo va a cámara lenta... menos tú."

func _man_r(r: Dictionary) -> float:
	if r["side"] == 0 and int(r["n"]) == 1 and Night.has_trinket("portero"):
		return MAN_R + 9.0
	return MAN_R

func _kick_time() -> float:
	return 0.34 if Night.has_trinket("mango") else KICK_TIME

func _ball_scale() -> float:
	return 0.85 if Night.has_trinket("tiza") else 1.0

func _update_score() -> void:
	score_label.text = "TÚ  %d  ·  %d  %s" % [score[0], score[1], str(rival["name"]).to_upper()]
	score_label.text += "     %d:%02d" % [int(time_left) / 60, int(time_left) % 60]

func _serve(toward_side: int) -> void:
	ball = Vector2(FIELD.size.x * 0.5, FIELD.size.y * 0.5)
	var dir := -1.0 if toward_side == 0 else 1.0
	vel = Vector2(dir * rng.randf_range(160, 230), rng.randf_range(-170, 170))
	state = "play"

func _men(r: Dictionary) -> Array:
	var out: Array = []
	var n: int = r["n"]
	var h := FIELD.size.y
	for k in n:
		var base_y := h * 0.5 if n == 1 else (k + 0.5) * h / n
		out.append(Vector2(float(r["x"]) * FIELD.size.x, base_y + float(r["offset"])))
	return out

func _range(r: Dictionary) -> float:
	var n: int = r["n"]
	if n == 1:
		return GOAL_HALF + 6.0
	return FIELD.size.y / (2.0 * n) - 4.0

func _process(delta: float) -> void:
	delta = minf(delta, 1.0 / 30.0)
	match state:
		"intro":
			timer -= delta
			if timer <= 0:
				_serve(rng.randi_range(0, 1))
		"goal":
			timer -= delta
			if timer <= 0:
				if score[0] >= WIN_GOALS or score[1] >= WIN_GOALS:
					_finish()
				else:
					_serve(rng.randi_range(0, 1))
		"play":
			time_left -= delta
			if time_left <= 0.0:
				time_left = 0.0
				_finish()
			else:
				focus_timer = maxf(0.0, focus_timer - delta)
				_step(delta * (0.4 if focus_timer > 0.0 else 1.0), delta)
	if state == "play" and Engine.get_process_frames() % 15 == 0:
		_update_score()
	queue_redraw()

func _step(delta: float, real_delta: float = -1.0) -> void:
	if real_delta < 0.0:
		real_delta = delta
	kick_timer = maxf(0.0, kick_timer - real_delta)
	distract_timer = maxf(0.0, distract_timer - delta)
	# --- control del jugador
	var my := get_local_mouse_position().y - FIELD.position.y
	ai_think -= delta
	ai_freeze = maxf(0.0, ai_freeze - delta)
	var think := ai_think <= 0.0
	if think:
		ai_think = 0.26 - skill * 0.2
	for r in rods:
		var rng_range := _range(r)
		if r["side"] == 0 and not autoplay:
			var t := clampf((my - FIELD.size.y * 0.5) / (FIELD.size.y * 0.5), -1.0, 1.0)
			r["target"] = t * rng_range
			if r["n"] > 1:
				# El muñeco más cercano al ratón se alinea con él.
				var band := FIELD.size.y / float(r["n"])
				var k := clampi(int(my / band), 0, int(r["n"]) - 1)
				r["target"] = clampf(my - (k + 0.5) * band, -rng_range, rng_range)
		elif think and not (r["side"] == 1 and ai_freeze > 0.0):
			var predict := ball.y + vel.y * 0.12
			var noise := rng.randf_range(-1.0, 1.0) * (1.0 - skill) * 46.0
			var n: int = r["n"]
			var base := FIELD.size.y * 0.5
			if n > 1:
				var band := FIELD.size.y / float(n)
				var k := clampi(int(predict / band), 0, n - 1)
				base = (k + 0.5) * band
			r["target"] = clampf(predict - base + noise, -rng_range, rng_range)
		var max_speed := 1600.0
		if r["side"] == 1 or autoplay:
			max_speed = 200.0 + (skill if r["side"] == 1 else player_skill) * 430.0
			if r["side"] == 1 and distract_timer > 0:
				max_speed *= 0.2
		var diff: float = r["target"] - r["offset"]
		var rod_dt := real_delta if (r["side"] == 0 and not autoplay) else delta
		var stepv := clampf(diff, -max_speed * rod_dt, max_speed * rod_dt)
		r["vel"] = stepv / maxf(delta, 0.001)
		r["offset"] = float(r["offset"]) + stepv
	# --- bola
	ball += vel * delta
	vel *= pow(0.82, delta)
	if vel.length() < 70:
		slow_timer += delta
		if slow_timer > 2.2:
			slow_timer = 0.0
			info.text = "Bola muerta. Saque neutral."
			_serve(rng.randi_range(0, 1))
			return
	else:
		slow_timer = 0.0
	if ball.y < BALL_R:
		ball.y = BALL_R
		vel.y = absf(vel.y)
	elif ball.y > FIELD.size.y - BALL_R:
		ball.y = FIELD.size.y - BALL_R
		vel.y = -absf(vel.y)
	var in_mouth := absf(ball.y - FIELD.size.y * 0.5) < GOAL_HALF
	if ball.x < BALL_R:
		if in_mouth:
			_goal(1)
			return
		ball.x = BALL_R
		vel.x = absf(vel.x)
	elif ball.x > FIELD.size.x - BALL_R:
		if in_mouth:
			_goal(0)
			return
		ball.x = FIELD.size.x - BALL_R
		vel.x = -absf(vel.x)
	# --- choques con muñecos
	for r in rods:
		var forward := 1.0 if r["side"] == 0 else -1.0
		for man in _men(r):
			var d: Vector2 = ball - man
			var dist := d.length()
			var mr := _man_r(r)
			if dist < mr + BALL_R and dist > 0.01:
				var nrm := d / dist
				ball = man + nrm * (mr + BALL_R + 0.5)
				var kicking := false
				if r["side"] == 0 and not autoplay:
					kicking = kick_timer > 0.0
				else:
					kicking = rng.randf() < 0.25 + skill * 0.6
					if r["side"] == 1 and distract_timer > 0:
						kicking = false
				var spin := float(r["vel"]) * 0.25
				if kicking:
					var aim := Vector2(forward, nrm.y * 0.8 + rng.randf_range(-0.35, 0.35)).normalized()
					if r["side"] == 1:
						var goal := Vector2(0.0, FIELD.size.y * 0.5 + rng.randf_range(-GOAL_HALF, GOAL_HALF) * 1.3)
						aim = (goal - man).normalized().lerp(aim, 0.35).normalized()
					else:
						# Chut del jugador: el rival puede reaccionar tarde.
						if rng.randf() < 1.0 - skill * 0.75:
							ai_freeze = 0.4
					var power := 720.0 + (skill * 200.0 if r["side"] == 1 else (260.0 if Night.has_trinket("mango") else 160.0))
					vel = aim * power * _ball_scale()
				else:
					vel = vel.bounce(nrm) * 0.75 if vel.dot(nrm) < 0 else vel
					vel.x += forward * 140.0
				vel.y += spin
				vel = vel.limit_length(1100.0 * _ball_scale())

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		kick_timer = _kick_time()

var _muneco_used := false

func _goal(side: int) -> void:
	score[side] += 1
	if side == 0 and Night.has_trinket("muneco") and not _muneco_used:
		_muneco_used = true
		score[0] += 1
	_update_score()
	state = "goal"
	timer = 1.1
	if side == 0:
		info.text = ["¡GOLAZO!", "¡Dentro!", "¡Toma ya!"][rng.randi_range(0, 2)]
	else:
		info.text = "%s: \"%s\"" % [rival["name"], ["¡Chúpate esa!", "Eso ha sido de rebote, pero cuenta.", "Así se hace, chaval."][rng.randi_range(0, 2)]]

func _finish() -> void:
	state = "over"
	if settled:
		return
	settled = true
	var won: bool = score[0] > score[1]
	var draw_game: bool = score[0] == score[1]
	var stake: int = int(rival["stake"])
	var gained := 0
	var extra := ""
	var lv: int = int(rival.get("level", Night.level("tino")))
	if draw_game:
		Night.log_moment("Futbolín: tablas con %s" % rival["name"], 0)
	elif won:
		Night.spend(mini(stake, Night.money))
		gained = Night.register_win("futbolin", stake, stake * 2) - stake
		Night.log_moment("Futbolín: ganas a %s (Nv%d)" % [rival["name"], lv], gained)
		if lv >= 3:
			if not Night.tino_forgave:
				Night.tino_forgave = true
				Night.reduce_debt(100, "Tino te perdona 100 €")
				extra = "Y te perdona 100 € de deuda."
		else:
			Night.levels["tino"] = lv + 1
			extra = "Tino sube a Nv%d: ahora se juega %d €." % [lv + 1, Catalog.TINO_STAKES[lv]]
	else:
		Night.spend(mini(stake, Night.money))
		Night.register_loss("futbolin")
		Night.log_moment("Futbolín: pierdes con %s" % rival["name"], -stake)
	Night.set_pause("minigame", false)
	Night.advance(MINUTES_COST)
	end_box = Control.new()
	end_box.size = size
	add_child(end_box)
	UIKit.panel(end_box, Rect2(390, 250, 500, 230), Color("#2a1a10"), UIKit.GOLD, 3)
	var title := "¡HAS GANADO! +%d €" % gained if won else "HAS PERDIDO · -%d €" % stake
	if draw_game:
		title = "TABLAS · nadie paga"
	var t := UIKit.label(title, 34, Color("#9ff59a") if won or draw_game else Color("#ff9b8a"))
	UIKit.place(t, Rect2(390, 270, 500, 44))
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_box.add_child(t)
	var q := UIKit.label("%s: \"%s\"" % [rival["name"], ("Me has pillado en un mal día. " + extra) if won else ("Se acabó el tiempo. Otro día te gano." if draw_game else "Vuelve cuando quieras... con dinero.")], 19, UIKit.CREAM)
	UIKit.place(q, Rect2(410, 320, 460, 60))
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_box.add_child(q)
	var back := UIKit.button("VOLVER AL BAR", "wood", 20)
	UIKit.place(back, Rect2(420, 400, 210, 50))
	back.pressed.connect(func(): main.go("bar"))
	end_box.add_child(back)
	var again := UIKit.button("REVANCHA", "red", 20)
	UIKit.place(again, Rect2(650, 400, 210, 50))
	again.disabled = Night.minutes_left() < MINUTES_COST or Night.over
	again.pressed.connect(func(): main.go("futbolin_lobby"))
	end_box.add_child(again)
	hunch_btn.disabled = true
	Night.check_broke()

func _exit_tree() -> void:
	Night.set_pause("minigame", false)

func _draw() -> void:
	var f := FIELD
	draw_rect(Rect2(Vector2.ZERO, size), Color("#1c110a"))
	# mueble
	draw_rect(Rect2(f.position - Vector2(40, 30), f.size + Vector2(80, 60)), Color("#5a3822"))
	draw_rect(Rect2(f.position - Vector2(30, 20), f.size + Vector2(60, 40)), Color("#3b2416"))
	draw_rect(f, Color("#2f7a33"))
	for i in 10:
		if i % 2 == 0:
			draw_rect(Rect2(f.position.x + f.size.x * i / 10.0, f.position.y, f.size.x / 10.0, f.size.y), Color("#358a3a"))
	var line := Color(1, 1, 1, 0.55)
	draw_rect(f, line, false, 3.0)
	draw_line(Vector2(f.get_center().x, f.position.y), Vector2(f.get_center().x, f.end.y), line, 3.0)
	draw_arc(f.get_center(), 60, 0, TAU, 32, line, 3.0)
	# porterías
	draw_rect(Rect2(f.position.x - 26, f.get_center().y - GOAL_HALF, 26, GOAL_HALF * 2), Color("#111"))
	draw_rect(Rect2(f.end.x, f.get_center().y - GOAL_HALF, 26, GOAL_HALF * 2), Color("#111"))
	# barras y muñecos
	for r in rods:
		var x: float = f.position.x + float(r["x"]) * f.size.x
		draw_line(Vector2(x, f.position.y - 26), Vector2(x, f.end.y + 26), Color("#b9bcc2"), 5.0)
		draw_rect(Rect2(x - 8, (f.position.y - 52) if r["side"] == 1 else (f.end.y + 26), 16, 26), Color("#222"))
		var body := Color("#c0392b") if r["side"] == 0 else Color("#2e5fa8")
		for man in _men(r):
			var p: Vector2 = f.position + man
			var extra := _man_r(r) - MAN_R
			draw_rect(Rect2(p - Vector2(10, 17 + extra), Vector2(20, 34 + extra * 2)), body)
			draw_rect(Rect2(p - Vector2(10, 17), Vector2(20, 6)), body.lightened(0.25))
			draw_circle(p, 7, Color("#f0c8a0"))
			draw_rect(Rect2(p + Vector2(-3, 12), Vector2(6, 9)), Color("#111"))
	# bola
	var bp := f.position + ball
	draw_circle(bp + Vector2(3, 4), BALL_R, Color(0, 0, 0, 0.35))
	draw_circle(bp, BALL_R, Color("#f4f1e8"))
	draw_circle(bp + Vector2(-3, -3), 3, Color.WHITE)
	if state == "intro":
		draw_string(UIKit.FONT_UI, Vector2(0, f.get_center().y), "¡A JUGAR!", HORIZONTAL_ALIGNMENT_CENTER, 1280, 60, UIKit.GOLD)
	if kick_timer > 0:
		draw_rect(Rect2(f.position.x, f.end.y + 34, f.size.x * kick_timer / _kick_time(), 6), UIKit.GOLD)
