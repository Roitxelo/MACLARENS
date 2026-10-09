extends Control

## Futbolín del fondo: Tino te espera. Cada vez que le ganas sube de nivel
## (más dinero en juego y juega mejor). Ganarle en Nv3 rebaja la deuda.

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")
const QUOTES := [
	"\"¿Un futbolín? Venga, que estoy calentando. 20 € y no lloras.\"",
	"\"Me has pillado antes. Ahora va en serio: 50 €.\"",
	"\"A muerte. 100 €. Si me ganas, te perdono 100 € de lo que me debes.\"",
]

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(BAR))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.66)
	dim.size = size
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	var title := UIKit.shadow(UIKit.label("FUTBOLÍN DEL FONDO · TINO TE ESPERA", 34, UIKit.GOLD))
	UIKit.place(title, Rect2(0, 112, 1280, 44))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := UIKit.shadow(UIKit.label("A 3 goles o 100 segundos. Mueve el ratón arriba y abajo para mover tus barras; haz clic para chutar fuerte. Cada partida dura 20 min de reloj.", 18, UIKit.CREAM))
	UIKit.place(sub, Rect2(140, 158, 1000, 50))
	sub.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)
	var lv := Night.level("tino")
	UIKit.panel(self, Rect2(330, 220, 620, 410), Color("#2a1a10"), Color("#8a6a3c"), 3)
	var pic := UIKit.texture_rect(UIKit.portrait("tino"), Rect2(350, 240, 220, 220))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var name_l := UIKit.label("TINO · Nv %d/3" % lv, 32, UIKit.GOLD)
	name_l.position = Vector2(590, 240)
	add_child(name_l)
	var y := 290.0
	for i in 3:
		var txt := "Nv%d · %s" % [i + 1, Catalog.CHARACTERS["tino"]["levels"][i]]
		var col := UIKit.CREAM if i == lv - 1 else (Color("#6f8f5f") if i < lv - 1 else Color("#7a6a52"))
		var l := UIKit.label(("> " if i == lv - 1 else "   ") + txt, 18, col)
		UIKit.place(l, Rect2(590, y, 340, 50))
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(l)
		y += 54
	var q := UIKit.label(QUOTES[lv - 1], 19, Color("#d8c8a8"))
	UIKit.place(q, Rect2(350, 476, 580, 56))
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(q)
	var stake: int = Catalog.TINO_STAKES[lv - 1]
	var b := UIKit.button("JUGAR POR %d €" % stake, "red", 24)
	UIKit.place(b, Rect2(500, 548, 280, 56))
	b.disabled = Night.money < stake or Night.minutes_left() < 20
	if Night.money < stake:
		b.tooltip_text = "No tienes bastante para cubrir la apuesta"
	b.pressed.connect(func(): main.go("futbolin", {"rival": {"id": "tino", "name": "Tino", "stake": stake, "skill": Catalog.TINO_SKILL[lv - 1], "level": lv}}))
	add_child(b)
	var back := UIKit.button("MEJOR NO", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 200, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
