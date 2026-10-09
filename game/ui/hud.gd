extends Control

## HUD fijo: dinero, hora, suerte y la pizarra con lo próximo de la noche.

var main: Control
var left_box: Panel
var money_label: Label
var clock_label: Label
var stars: Control
var right_box: Panel
var debt_label: Label
var agenda_label: Label
var speed_button: Button
var pause_button: Button
var compact := false
var streak_label: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_box = UIKit.panel(self, Rect2(8, 8, 330, 48), Color(0.07, 0.04, 0.02, 0.88), Color("#8a6a3c"), 2)
	money_label = UIKit.shadow(UIKit.label("", 24, UIKit.GOLD))
	UIKit.place(money_label, Rect2(16, 12, 120, 40))
	money_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(money_label)
	clock_label = UIKit.shadow(UIKit.label("", 30, Color("#7dff8a"), true))
	UIKit.place(clock_label, Rect2(140, 10, 90, 44))
	clock_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(clock_label)
	stars = Control.new()
	stars.position = Vector2(232, 14)
	stars.size = Vector2(100, 36)
	stars.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stars.draw.connect(_draw_stars)
	stars.tooltip_text = "Suerte: corazonadas que quedan esta noche"
	add_child(stars)

	streak_label = UIKit.label("", 18, Color("#ffb347"), true)
	streak_label.add_theme_stylebox_override("normal", UIKit.box(Color(0.07, 0.04, 0.02, 0.88), Color("#8a6a3c"), 2, 2, 8))
	streak_label.position = Vector2(8, 60)
	add_child(streak_label)
	right_box = UIKit.panel(self, Rect2(958, 8, 314, 96), Color(0.07, 0.04, 0.02, 0.88), Color("#8a6a3c"), 2)
	debt_label = UIKit.shadow(UIKit.label("", 17, UIKit.CREAM))
	UIKit.place(debt_label, Rect2(966, 12, 190, 24))
	add_child(debt_label)
	agenda_label = UIKit.label("", 19, Color("#cfe9d9"), true)
	UIKit.place(agenda_label, Rect2(966, 36, 302, 66))
	add_child(agenda_label)
	speed_button = UIKit.button("x1", "wood", 16)
	UIKit.place(speed_button, Rect2(1214, 12, 52, 26))
	speed_button.tooltip_text = "Velocidad del reloj"
	speed_button.pressed.connect(func(): Night.cycle_speed())
	add_child(speed_button)
	pause_button = UIKit.button("II", "wood", 16)
	UIKit.place(pause_button, Rect2(1158, 12, 52, 26))
	pause_button.tooltip_text = "Pausar el reloj (P)"
	pause_button.pressed.connect(func(): Night.toggle_user_pause())
	add_child(pause_button)
	refresh()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and not event.echo and (event as InputEventKey).keycode == KEY_P and visible and not compact:
		Night.toggle_user_pause()

func set_compact(on: bool) -> void:
	compact = on
	if right_box == null:
		return
	right_box.visible = not on
	debt_label.visible = not on
	agenda_label.visible = not on
	speed_button.visible = not on
	pause_button.visible = not on

func refresh() -> void:
	if money_label == null:
		return
	money_label.text = "%d €" % Night.money
	money_label.add_theme_color_override("font_color", UIKit.GOLD if Night.money >= 20 else Color("#ff8a70"))
	clock_label.text = Night.clock_text()
	var left := Night.minutes_left()
	clock_label.add_theme_color_override("font_color", Color("#7dff8a") if left > 60 else Color("#ff6a5a"))
	var missing := maxi(0, Night.debt - Night.money)
	debt_label.text = "DEUDA %d € · %s" % [Night.debt, "¡CUBIERTA!" if missing == 0 else "faltan %d €" % missing]
	streak_label.text = Night.streak_text()
	streak_label.add_theme_color_override("font_color", Color("#ffb347") if Night.streak > 0 else Color("#8a7a62"))
	streak_label.reset_size()
	var lines: Array = []
	for item in Night.agenda(3):
		lines.append(item["text"])
	agenda_label.text = "\n".join(lines) if not lines.is_empty() else "Nada más esta noche"
	speed_button.text = "x%d" % Night.speed
	var paused := Night.pauses.has("user")
	pause_button.text = ">" if paused else "II"
	if paused:
		clock_label.add_theme_color_override("font_color", Color("#7ab0ff"))
	stars.queue_redraw()

func _draw_stars() -> void:
	for i in Night.max_luck:
		var c := Vector2(14 + i * (30 if Night.max_luck <= 3 else 23), 17)
		var pts := PackedVector2Array()
		for k in 10:
			var r := 12.0 if k % 2 == 0 else 5.0
			var a := -PI / 2 + k * PI / 5
			pts.append(c + Vector2(cos(a), sin(a)) * r)
		var col := UIKit.GOLD if i < Night.luck else Color(0.3, 0.25, 0.2)
		stars.draw_colored_polygon(pts, col)
		pts.append(pts[0])
		stars.draw_polyline(pts, Color("#5a3a12"), 1.5)
