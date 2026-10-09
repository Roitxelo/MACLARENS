extends Control

## Escena principal de la noche. Mantiene el HUD y los avisos por encima
## y cambia entre pantallas (bar, máquina, TVs, periódico, minijuegos...).

const SCREENS := {
	"title": preload("res://ui/screens/title_screen.gd"),
	"bar": preload("res://ui/screens/bar_screen.gd"),
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
}
const HudScript := preload("res://ui/hud.gd")

var screen_layer: Control
var current: Control
var current_name := ""
var hud: Control
var toast_box: VBoxContainer
var fade: ColorRect

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
	if current != null:
		current.queue_free()
		current = null
	current_name = screen_name
	var screen: Control = SCREENS[screen_name].new()
	screen.set("main", self)
	screen.set("args", args)
	screen.size = Vector2(1280, 720)
	screen_layer.add_child(screen)
	current = screen
	hud.visible = screen_name not in ["title", "end"]
	hud.call("set_compact", screen_name in ["billar", "cards"])
	toast_box.visible = screen_name not in ["title", "end", "notebook", "paper", "billar"]
	fade.color.a = 0.7
	create_tween().tween_property(fade, "color:a", 0.0, 0.25)
	_on_changed()

func _on_changed() -> void:
	if hud.visible:
		hud.call("refresh")
	if current != null and current.has_method("refresh"):
		current.call("refresh")

func _on_toast(text: String, kind: String) -> void:
	if current_name in ["title", "end"]:
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
	while toast_box.get_child_count() > 4:
		toast_box.get_child(0).free()
	var t := create_tween()
	t.tween_interval(3.6)
	t.tween_property(l, "modulate:a", 0.0, 0.5)
	t.tween_callback(l.queue_free)

func _on_night_over(reason: String) -> void:
	# Se deja un instante para que se vean los últimos avisos.
	await get_tree().create_timer(1.2).timeout
	go("end", {"reason": reason})

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE and current_name not in ["title", "end", "bar", "billar", "cards"]:
			go("bar")
