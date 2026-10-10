extends Control

## Portada: la deuda con Tino y lo que ofrece la noche.

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(BAR))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.64)
	dim.size = size
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	var title := UIKit.shadow(UIKit.label("McLARENS", 82, UIKit.GOLD))
	UIKit.place(title, Rect2(0, 22, 1280, 100))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := UIKit.shadow(UIKit.label("La última combinada", 30, UIKit.CREAM))
	UIKit.place(sub, Rect2(0, 116, 1280, 40))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)
	var debt_card := UIKit.panel(self, Rect2(170, 174, 940, 166), Color(0.06, 0.035, 0.02, 0.94), Color("#8a6a3c"), 3)
	debt_card.name = "debt_card"
	var pic := UIKit.texture_rect(UIKit.portrait("tino"), Rect2(184, 184, 146, 146))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var lines := UIKit.label("\n".join(GameTexts.TITLE_LINES), 28, UIKit.CREAM, true)
	UIKit.place(lines, Rect2(356, 194, 720, 126))
	lines.add_theme_constant_override("line_spacing", 8)
	add_child(lines)
	var portraits := {"machine": "buho", "billar": "tino", "cards": "chencho", "lucia": "lucia"}
	for i in GameTexts.TITLE_PLACES.size():
		var place: Dictionary = GameTexts.TITLE_PLACES[i]
		_place_card(place, str(portraits[place["icon"]]), Rect2(80 + i * 285, 370, 265, 176))
	var start := UIKit.button("ABRIR EL BAR · 18:00", "red", 30)
	UIKit.place(start, Rect2(450, 590, 380, 76))
	start.pressed.connect(func(): main.go("bar"))
	add_child(start)
	var small := UIKit.label("Juego de ficción. Ningún caballo fue sobornado.", 14, Color("#8a7a5a"))
	UIKit.place(small, Rect2(0, 688, 1280, 24))
	small.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(small)

func _place_card(place: Dictionary, portrait_id: String, rect: Rect2) -> void:
	var card := UIKit.panel(self, rect, Color(0.055, 0.035, 0.025, 0.94), Color("#8a6a3c"), 2)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic := UIKit.texture_rect(UIKit.portrait(portrait_id), Rect2(rect.position.x + 72, rect.position.y + 10, 120, 112))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var label := UIKit.label(str(place["label"]), 20, UIKit.CREAM, true)
	UIKit.place(label, Rect2(rect.position.x + 12, rect.position.y + 130, rect.size.x - 24, 34))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(label)
