extends Control

## La libreta: fichas visuales de tu gente, objetos y racha.

var main: Control
var args: Dictionary

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#24140b")
	bg.size = size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	var book := UIKit.panel(self, Rect2(40, 108, 1200, 540), Color("#5a3822"), Color("#2a170d"), 4)
	book.name = "book"
	var left := UIKit.panel(self, Rect2(56, 120, 580, 516), Color("#eadcbc"), Color("#b8a27a"), 2)
	left.name = "left"
	var right := UIKit.panel(self, Rect2(644, 120, 580, 516), Color("#eadcbc"), Color("#b8a27a"), 2)
	right.name = "right"

	var t1 := UIKit.label("TU GENTE", 30, UIKit.PAPER_RED)
	t1.position = Vector2(76, 126)
	add_child(t1)
	var y := 166.0
	for who in ["buho", "cortado", "chencho", "tino"]:
		_character_card(who, y)
		y += 116

	var t2 := UIKit.label("OBJETOS  (%d/%d)" % [Night.trinkets.size(), Catalog.MAX_TRINKETS], 30, UIKit.PAPER_RED)
	t2.position = Vector2(664, 126)
	add_child(t2)
	y = 174.0
	for i in Catalog.MAX_TRINKETS:
		var col := i % 2
		var row := i / 2
		_trinket_card(i, Rect2(664 + col * 270, y + row * 88, 258, 76))
	var t3 := UIKit.label("LA RACHA", 26, UIKit.PAPER_RED)
	t3.position = Vector2(664, 446)
	add_child(t3)
	var el := UIKit.label(GameTexts.streak_line(), 18, Color("#3b2a1a"), true)
	UIKit.place(el, Rect2(664, 480, 540, 48))
	el.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(el)
	var t4 := UIKit.label("CÓMO SUBIR DE NIVEL", 22, UIKit.PAPER_RED)
	t4.position = Vector2(664, 540)
	add_child(t4)
	var how := UIKit.label(GameTexts.HOW_TO_LEVEL, 17, Color("#3b2a1a"))
	UIKit.place(how, Rect2(664, 570, 540, 42))
	how.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(how)

	var back := UIKit.button("CERRAR LA LIBRETA", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 260, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)

func _character_card(who: String, y: float) -> void:
	var data := GameTexts.character_card(who)
	var card := UIKit.panel(self, Rect2(68, y - 4, 552, 106), Color("#f0e3c3"), Color("#c6a875"), 1)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var pic := UIKit.texture_rect(UIKit.portrait(who), Rect2(76, y, 88, 92))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var name_l := UIKit.label("%s · %s" % [data["name"], data["game"]], 21, UIKit.PAPER_INK, true)
	UIKit.place(name_l, Rect2(176, y, 310, 28))
	add_child(name_l)
	var lv: int = data["level"]
	var lvl := UIKit.label("NV %d" % lv, 18, UIKit.PAPER_RED, true)
	UIKit.place(lvl, Rect2(500, y, 60, 26))
	add_child(lvl)
	_level_pips(Vector2(554, y + 8), lv)
	var now := UIKit.label(str(data["now"]), 18, Color("#3b2a1a"))
	UIKit.place(now, Rect2(176, y + 30, 426, 28))
	add_child(now)
	var next := "NIVEL MÁXIMO"
	if str(data["next"]) != "":
		next = "%s  →  %s" % [data["how"], data["next"]]
	var next_l := UIKit.label(next, 15, Color("#765a38"))
	UIKit.place(next_l, Rect2(176, y + 60, 426, 34))
	next_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(next_l)

func _trinket_card(index: int, rect: Rect2) -> void:
	var filled := index < Night.trinkets.size()
	var card := UIKit.panel(self, rect, Color("#f0e3c3") if filled else Color("#dfcfaa"), Color("#c6a875"), 1)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var badge := UIKit.label("%d" % (index + 1), 20, UIKit.CREAM, true)
	badge.add_theme_stylebox_override("normal", UIKit.box(UIKit.PAPER_RED if filled else Color("#9c8761"), Color.TRANSPARENT, 0, 1, 8))
	UIKit.place(badge, Rect2(rect.position.x + 8, rect.position.y + 12, 38, 38))
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(badge)
	if not filled:
		var empty := UIKit.label("HUECO LIBRE", 16, Color("#8a7350"), true)
		UIKit.place(empty, Rect2(rect.position.x + 56, rect.position.y + 24, 188, 26))
		add_child(empty)
		return
	var id: String = Night.trinkets[index]
	var tr: Dictionary = Catalog.TRINKETS[id]
	var name_l := UIKit.label(str(tr["name"]), 17, UIKit.PAPER_INK, true)
	UIKit.place(name_l, Rect2(rect.position.x + 56, rect.position.y + 8, 190, 24))
	add_child(name_l)
	var effect := UIKit.label(str(GameTexts.TRINKET_SHORT[id]), 14, Color("#6b5236"))
	UIKit.place(effect, Rect2(rect.position.x + 56, rect.position.y + 36, 190, 28))
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(effect)

func _level_pips(at: Vector2, lv: int) -> void:
	for i in 3:
		var r := ColorRect.new()
		r.color = UIKit.PAPER_RED if i < lv else Color("#cdb684")
		UIKit.place(r, Rect2(at.x + i * 22, at.y, 18, 10))
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(r)
