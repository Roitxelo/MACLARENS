extends Control

## Penalti del Búho (Nv3): una mirilla recorre la portería; haz clic (o
## ESPACIO) para chutar. El portero se tira a un tercio al azar y tapa una
## franja: pegado al palo entra siempre, fuera de los palos es fuera.

signal finished(scored: bool)

const GOAL := Rect2(390, 220, 500, 190)
const SPEED := 1.6           # unidades de portería por segundo
const AMP := 1.15            # la mirilla sale un poco de los palos
const KEEPER_CENTERS := [-0.55, 0.0, 0.55]

var match_id := ""
var t := 0.0
var aim := 0.0
var state := "aim"           # aim, shot, done
var shot_t := 0.0
var keeper := 1
var keeper_half := 0.25
var scored := false
var hunch := false
var info: Label
var hunch_btn: Button
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	size = Vector2(1280, 720)
	mouse_filter = Control.MOUSE_FILTER_STOP
	keeper_half = 0.19 if Night.has_trinket("silbato") else 0.25
	info = UIKit.shadow(UIKit.label("Haz clic (o ESPACIO) para chutar. Pegado al palo, el portero no llega.", 22, UIKit.CREAM))
	UIKit.place(info, Rect2(0, 460, 1280, 40))
	info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(info)
	hunch_btn = UIKit.button("CORAZONADA: ENGAÑAR AL PORTERO", "gold", 18)
	UIKit.place(hunch_btn, Rect2(490, 520, 300, 44))
	hunch_btn.tooltip_text = "Gasta 1 de suerte: el portero se tira al lado contrario"
	hunch_btn.disabled = Night.luck <= 0
	hunch_btn.pressed.connect(func():
		if not hunch and Night.spend_luck():
			hunch = true
			hunch_btn.disabled = true
			info.text = "Le miras a los ojos... se va a tirar al otro lado.")
	add_child(hunch_btn)

func _process(delta: float) -> void:
	t += delta
	if state == "aim":
		var phase := fmod(t * SPEED, AMP * 4.0)
		aim = phase - AMP if phase < AMP * 2.0 else AMP * 3.0 - phase
	elif state == "shot":
		shot_t += delta
		if shot_t > 0.6 and state != "done":
			state = "done"
			info.text = "¡GOOOL!" if scored else ("¡PARADÓN!" if absf(aim) <= 1.0 else "¡Fuera! Al palo... de la grada.")
			hunch_btn.visible = false
			await get_tree().create_timer(1.2).timeout
			finished.emit(scored)
			queue_free()
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_shoot()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and (event as InputEventKey).keycode == KEY_SPACE:
		_shoot()

func _shoot() -> void:
	if state != "aim":
		return
	state = "shot"
	if hunch:
		# se tira al tercio más lejano de donde va la bola
		keeper = 0 if aim > 0.0 else 2
	else:
		keeper = rng.randi_range(0, 2)
	var kc: float = KEEPER_CENTERS[keeper]
	scored = absf(aim) <= 1.0 and absf(aim - kc) > keeper_half

func _gx(u: float) -> float:
	return GOAL.position.x + GOAL.size.x * (0.5 + u * 0.5)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color(0, 0, 0, 0.78))
	# césped y portería
	draw_rect(Rect2(GOAL.position.x - 160, GOAL.end.y, GOAL.size.x + 320, 60), Color("#2f7a33"))
	draw_rect(Rect2(GOAL.position - Vector2(8, 8), Vector2(GOAL.size.x + 16, 8)), Color.WHITE)
	draw_rect(Rect2(GOAL.position.x - 8, GOAL.position.y, 8, GOAL.size.y), Color.WHITE)
	draw_rect(Rect2(GOAL.end.x, GOAL.position.y, 8, GOAL.size.y), Color.WHITE)
	for i in 11:
		var x := GOAL.position.x + GOAL.size.x * i / 10.0
		draw_line(Vector2(x, GOAL.position.y), Vector2(x, GOAL.end.y), Color(1, 1, 1, 0.15), 1.0)
	for j in 5:
		var y := GOAL.position.y + GOAL.size.y * j / 4.0
		draw_line(Vector2(GOAL.position.x, y), Vector2(GOAL.end.x, y), Color(1, 1, 1, 0.15), 1.0)
	# portero
	var kx := _gx(0.0)
	var ky := GOAL.end.y - 70
	if state != "aim":
		var p := clampf(shot_t / 0.35, 0.0, 1.0)
		kx = lerpf(_gx(0.0), _gx(KEEPER_CENTERS[keeper]), p)
	var half_px := keeper_half * GOAL.size.x * 0.5
	draw_rect(Rect2(kx - half_px, ky, half_px * 2, 70), Color("#e8b628"))
	draw_circle(Vector2(kx, ky - 12), 14, Color("#f0c8a0"))
	# mirilla / balón
	var ax := _gx(aim)
	if state == "aim":
		draw_line(Vector2(ax, GOAL.position.y - 30), Vector2(ax, GOAL.end.y + 10), UIKit.GOLD, 3.0)
		draw_circle(Vector2(ax, GOAL.position.y + GOAL.size.y * 0.5), 12, Color(1, 0.8, 0.3, 0.5))
	else:
		var p2 := clampf(shot_t / 0.4, 0.0, 1.0)
		var from := Vector2(_gx(0.0), GOAL.end.y + 50)
		var to := Vector2(ax, GOAL.position.y + GOAL.size.y * 0.45)
		draw_circle(from.lerp(to, p2), 11, Color.WHITE)
	draw_string(UIKit.FONT_UI, Vector2(0, 170), "PENALTI DEL BÚHO", HORIZONTAL_ALIGNMENT_CENTER, 1280, 44, UIKit.GOLD)
