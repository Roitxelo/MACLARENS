extends Control

## La libreta: tu gente (qué hace cada uno ahora y cómo subirlo), tus objetos
## y la racha. Una línea por cosa: nada de reglas largas (T24).

const GAME_WORD := {"football": "fútbol", "horse": "caballos", "cards": "cartas", "billar": "billar"}

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
		var c: Dictionary = Catalog.CHARACTERS[who]
		var lv := Night.level(who)
		var pic := UIKit.texture_rect(UIKit.portrait(who), Rect2(72, y, 92, 92))
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(pic)
		var name_l := UIKit.label("%s · %s" % [c["name"], GAME_WORD[c["game"]]], 22, UIKit.PAPER_INK)
		name_l.position = Vector2(176, y - 2)
		add_child(name_l)
		var lvl := UIKit.label("Nv %d/3" % lv, 20, UIKit.PAPER_RED)
		lvl.position = Vector2(490, y - 2)
		add_child(lvl)
		_level_pips(Vector2(552, y + 8), lv)
		var now := UIKit.label("AHORA  " + str(c["short"][lv - 1]), 19, Color("#3b2a1a"))
		UIKit.place(now, Rect2(176, y + 30, 446, 26))
		add_child(now)
		var nxt := "Nivel máximo."
		if lv < 3:
			var cost := "" if who == "tino" else " (%d €)" % Night.round_price(who)
			nxt = "SUBIR  %s%s → %s" % [c["how"], cost, c["short"][lv]]
		var nl := UIKit.label(nxt, 16, Color("#6b5236"))
		UIKit.place(nl, Rect2(176, y + 58, 446, 44))
		nl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(nl)
		y += 116

	var t2 := UIKit.label("OBJETOS  (%d/%d)" % [Night.trinkets.size(), Catalog.MAX_TRINKETS], 30, UIKit.PAPER_RED)
	t2.position = Vector2(664, 126)
	add_child(t2)
	y = 168.0
	for i in Catalog.MAX_TRINKETS:
		var txt := "— hueco libre —"
		var col := Color("#8a7350")
		if i < Night.trinkets.size():
			var tr: Dictionary = Catalog.TRINKETS[Night.trinkets[i]]
			txt = "%s: %s" % [tr["name"], tr["text"]]
			col = UIKit.PAPER_INK
		var l := UIKit.label(txt, 17, col)
		UIKit.place(l, Rect2(664, y, 540, 44))
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(l)
		y += 46
	var t3 := UIKit.label("LA RACHA", 26, UIKit.PAPER_RED)
	t3.position = Vector2(664, 404)
	add_child(t3)
	var el := UIKit.label("%s\nCada acierto seguido suma +10 %% al siguiente premio (hasta +50 %%). Un fallo la rompe." % Night.streak_text(), 17, Color("#3b2a1a"))
	UIKit.place(el, Rect2(664, 438, 540, 70))
	el.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(el)
	var t4 := UIKit.label("CÓMO SUBIR DE NIVEL", 22, UIKit.PAPER_RED)
	t4.position = Vector2(664, 520)
	add_child(t4)
	var how := UIKit.label("Búho, Cortado y Chencho: invítales a una ronda en la barra de Lucía.\nTino: gánale una serie de billar.\nLo que subes se queda para las noches siguientes.", 16, Color("#3b2a1a"))
	UIKit.place(how, Rect2(664, 550, 540, 80))
	how.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(how)

	var back := UIKit.button("CERRAR LA LIBRETA", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 260, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)

func _level_pips(at: Vector2, lv: int) -> void:
	for i in 3:
		var r := ColorRect.new()
		r.color = UIKit.PAPER_RED if i < lv else Color("#cdb684")
		UIKit.place(r, Rect2(at.x + i * 22, at.y, 18, 10))
		r.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(r)
