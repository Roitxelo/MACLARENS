extends Control

## La libreta: tu gente (niveles), tus objetos y cómo va la racha.

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
		var name_l := UIKit.label("%s  ·  %s" % [c["name"], c["role"]], 22, UIKit.PAPER_INK)
		name_l.position = Vector2(176, y - 2)
		add_child(name_l)
		var lvl := UIKit.label("Nv %d/3" % lv, 20, UIKit.PAPER_RED)
		lvl.position = Vector2(176, y + 22)
		add_child(lvl)
		_level_pips(Vector2(250, y + 30), lv)
		var now := UIKit.label(c["levels"][lv - 1], 17, Color("#3b2a1a"))
		UIKit.place(now, Rect2(176, y + 46, 446, 24))
		now.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(now)
		var nxt := ""
		if lv < 3:
			if who == "tino":
				nxt = "Siguiente: gánale al futbolín → %s" % c["levels"][lv]
			else:
				nxt = "Ronda en la barra (%d €) → %s" % [Night.round_price(who), c["levels"][lv]]
		else:
			nxt = "Nivel máximo."
		var nl := UIKit.label(nxt, 15, Color("#6b5236"))
		UIKit.place(nl, Rect2(176, y + 70, 446, 40))
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
		var l := UIKit.label(txt, 18, col)
		UIKit.place(l, Rect2(664, y, 540, 44))
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(l)
		y += 48
	var t3 := UIKit.label("LA RACHA", 26, UIKit.PAPER_RED)
	t3.position = Vector2(664, 412)
	add_child(t3)
	var expl := "%s\nCada victoria seguida suma +0,1 al multiplicador del beneficio de la siguiente (máximo x1,5). Una derrota la rompe. Solo cuentan apuestas de 10 € o más. Mejor racha de la noche: %d." % [Night.streak_text(), Night.best_streak]
	var el := UIKit.label(expl, 17, Color("#3b2a1a"))
	UIKit.place(el, Rect2(664, 446, 540, 100))
	el.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(el)
	var combos := UIKit.label("Combos: lee la PRESIÓN y entra antes que la casa (Búho) · Gafas + Fusta: elige el caballo en forma y arréale bien · Chencho Nv3 + Chuleta: cuenta cartas contra un borracho · Tiza + Taco + Guante para los imposibles de Tino.", 15, Color("#6b5236"))
	UIKit.place(combos, Rect2(664, 556, 540, 70))
	combos.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(combos)

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
