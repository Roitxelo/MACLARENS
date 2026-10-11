extends Control

## Escena principal de la noche. Mantiene el HUD y los avisos por encima
## y cambia entre pantallas (bar, máquina, TVs, periódico, minijuegos...).

const SCREENS := {
	"title": preload("res://ui/screens/title_screen.gd"),
	"bar": preload("res://ui/screens/bar_screen.gd"),
	"salon": preload("res://ui/screens/salon_screen.gd"),
	"machine": preload("res://ui/screens/machine_screen.gd"),
	"match_tv": preload("res://ui/screens/match_tv_screen.gd"),
	"race_tv": preload("res://ui/screens/race_screen.gd"),
	"paper": preload("res://ui/screens/paper_screen.gd"),
	"notebook": preload("res://ui/screens/notebook_screen.gd"),
	"shop": preload("res://ui/screens/shop_screen.gd"),
	"billar_lobby": preload("res://ui/screens/billar_lobby_screen.gd"),
	"billar": preload("res://ui/minigames/billar.gd"),
	"cards": preload("res://ui/minigames/mayor_menor.gd"),
	"end": preload("res://ui/screens/end_screen.gd"),
	"stats": preload("res://ui/screens/stats_screen.gd"),
}
const HudScript := preload("res://ui/hud.gd")
const SCREEN_HELP := {
	"bar": "bar",
	"salon": "salon",
	"machine": "machine",
	"match_tv": "pressure",
	"race_tv": "whip",
	"cards": "cards",
	"billar": "billar",
	"shop": "shop",
	"end": "end",
}

var screen_layer: Control
var current: Control
var current_name := ""
var hud: Control
var toast_box: VBoxContainer
var toast_limit := 4
var fade: ColorRect
var help_overlay: Control
var seen_help := {}

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size = Vector2(1280, 720)
	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	screen_layer = Control.new()
	screen_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(screen_layer)
	hud = HudScript.new()
	hud.main = self
	add_child(hud)
	toast_box = VBoxContainer.new()
	toast_box.position = Vector2(8, 380)
	toast_box.size = Vector2(236, 262)
	toast_box.alignment = BoxContainer.ALIGNMENT_END
	toast_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	toast_box.add_theme_constant_override("separation", 4)
	add_child(toast_box)
	fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(fade)
	Night.toast.connect(_on_toast)
	Night.changed.connect(_on_changed)
	Night.night_over.connect(_on_night_over)
	Night.new_night()
	go("title")

func go(screen_name: String, args: Dictionary = {}) -> void:
	var previous_name := current_name
	_close_help()
	if current != null:
		current.queue_free()
		current = null
	if screen_name == "bar" and previous_name in ["title", "end", "stats"]:
		_clear_toasts()
	current_name = screen_name
	var screen: Control = SCREENS[screen_name].new()
	screen.set("main", self)
	screen.set("args", args)
	screen.size = Vector2(1280, 720)
	screen_layer.add_child(screen)
	current = screen
	hud.visible = screen_name not in ["title", "end", "stats"]
	hud.call("set_compact", screen_name in ["billar", "cards"])
	toast_box.visible = screen_name not in ["title", "end", "stats", "notebook", "paper", "billar"]
	_layout_toasts(screen_name)
	fade.color.a = 0.7
	create_tween().tween_property(fade, "color:a", 0.0, 0.25)
	_on_changed()
	var help_key: String = SCREEN_HELP.get(screen_name, "")
	if help_key != "":
		show_help(help_key)

func _on_changed() -> void:
	if hud.visible:
		hud.call("refresh")
	if current != null and current.has_method("refresh"):
		current.call("refresh")

func _on_toast(text: String, kind: String) -> void:
	if current_name in ["title", "end", "stats"]:
		return
	var color := UIKit.CREAM
	var bg := Color(0.08, 0.05, 0.03, 0.92)
	match kind:
		"win": color = Color("#9ff59a")
		"lose": color = Color("#ff9b8a")
		"goal": color = UIKit.GOLD
		"horse": color = Color("#f7d9a0")
		"ticket": color = UIKit.SCREEN_TEXT
	var l := UIKit.label(text, 16, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size = Vector2(236, 0)
	l.add_theme_stylebox_override("normal", UIKit.box(bg, color.darkened(0.4), 2, 3, 10))
	toast_box.add_child(l)
	while toast_box.get_child_count() > toast_limit:
		toast_box.get_child(0).free()
	var t := create_tween()
	t.tween_interval(3.6)
	t.tween_property(l, "modulate:a", 0.0, 0.5)
	t.tween_callback(l.queue_free)

func _clear_toasts() -> void:
	for child in toast_box.get_children():
		child.queue_free()

func show_help(key: String) -> void:
	if seen_help.has(key) or not GameTexts.HELP.has(key):
		return
	_close_help()
	seen_help[key] = true
	var copy: Array = GameTexts.HELP[key]
	help_overlay = Control.new()
	help_overlay.position = Vector2(310, 500)
	help_overlay.size = Vector2(660, 140)
	help_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	help_overlay.z_index = 20
	add_child(help_overlay)
	var card := UIKit.panel(help_overlay, Rect2(0, 0, 660, 140), Color(0.05, 0.035, 0.025, 0.97), UIKit.GOLD, 3)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var title := UIKit.label(str(copy[0]), 25, UIKit.GOLD, true)
	UIKit.place(title, Rect2(20, 12, 500, 34))
	help_overlay.add_child(title)
	var body := UIKit.label(str(copy[1]), 18, UIKit.CREAM)
	UIKit.place(body, Rect2(20, 48, 500, 76))
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help_overlay.add_child(body)
	var close := UIKit.button("ENTENDIDO", "wood", 17)
	UIKit.place(close, Rect2(526, 82, 118, 42))
	close.pressed.connect(_close_help)
	help_overlay.add_child(close)
	var overlay_id := help_overlay.get_instance_id()
	get_tree().create_timer(8.0).timeout.connect(func():
		if is_instance_valid(help_overlay) and help_overlay.get_instance_id() == overlay_id:
			_close_help())

func _close_help() -> void:
	if is_instance_valid(help_overlay):
		help_overlay.queue_free()
	help_overlay = null

func _layout_toasts(screen_name: String) -> void:
	# El HUD deja un hueco central arriba. En las TVs y el lobby se usa
	# como carril de eventos para no tapar el contenido que cambia en vivo.
	match screen_name:
		"race_tv", "match_tv", "billar_lobby", "salon":
			toast_box.position = Vector2(346, 8)
			toast_box.size = Vector2(604, 96)
			toast_box.alignment = BoxContainer.ALIGNMENT_BEGIN
			toast_limit = 2
		"cards":
			toast_box.position = Vector2(958, 8)
			toast_box.size = Vector2(314, 96)
			toast_box.alignment = BoxContainer.ALIGNMENT_BEGIN
			toast_limit = 2
		_:
			toast_box.position = Vector2(8, 104)
			toast_box.size = Vector2(236, 262)
			toast_box.alignment = BoxContainer.ALIGNMENT_BEGIN
			toast_limit = 4
	while toast_box.get_child_count() > toast_limit:
		toast_box.get_child(0).free()

func _on_night_over(reason: String) -> void:
	# Se deja un instante para que se vean los últimos avisos.
	await get_tree().create_timer(1.2).timeout
	go("end", {"reason": reason})

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE and current_name not in ["title", "end", "stats", "bar", "billar", "cards"]:
			go("bar")
