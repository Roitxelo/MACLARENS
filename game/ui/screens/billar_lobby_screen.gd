extends Control

## Billar del fondo: Tino prepara "tiros imposibles". Una serie son 3 mesas
## con una misión; si aciertas 2, ganas la apuesta y Tino sube de nivel.
## Ganarle en Nv3 rebaja la deuda (una vez por noche).

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")
const QUOTES := [
	"\"Te pongo tres tiros. Si metes dos, te pago lo que apuestes. Si no, me lo das tú.\"",
	"\"Ahora con truco: bandas, carambolas y pasillos. Te pago el doble.\"",
	"\"Los imposibles. Te pago el triple... y si me ganas, te perdono 100 € de lo que me debes.\"",
]

var main: Control
var args: Dictionary
var stake := 20
var stake_label: Label
var accept: Button

func _set_stake(v: int) -> void:
	var lv := Night.level("tino")
	stake = clampi(v, 10, maxi(10, mini(Catalog.TINO_MAX_STAKE[lv - 1], Night.money)))
	stake_label.text = "%d €" % stake
	var pay: int = Catalog.TINO_PAYOUT[lv - 1]
	accept.text = "ACEPTAR · ganas %d €" % (stake * pay)
	accept.disabled = Night.money < stake or Night.minutes_left() < 20
	accept.tooltip_text = "Si metes 2 de 3, Tino te paga %d a 1" % pay

func _ready() -> void:
	add_child(UIKit.texture_rect(BAR))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.66)
	dim.size = size
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	var title := UIKit.shadow(UIKit.label("BILLAR DEL FONDO · TIRO IMPOSIBLE", 34, UIKit.GOLD))
	UIKit.place(title, Rect2(0, 112, 1280, 44))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := UIKit.shadow(UIKit.label("Tino te prepara 3 mesas con una misión cada una; mete 2 y ganas. Apunta con el ratón (← → para afinar), mantén el clic para cargar y suelta. Cada serie dura 20 min de reloj.", 18, UIKit.CREAM))
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
	var max_stake: int = Catalog.TINO_MAX_STAKE[lv - 1]
	stake = clampi(stake, 10, maxi(10, mini(max_stake, Night.money)))
	var minus := UIKit.button("-", "wood", 26)
	UIKit.place(minus, Rect2(372, 548, 50, 56))
	minus.pressed.connect(func(): _set_stake(stake - 10))
	add_child(minus)
	stake_label = UIKit.label("", 26, UIKit.GOLD)
	stake_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stake_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stake_label.add_theme_stylebox_override("normal", UIKit.box(Color("#1a0f0a"), UIKit.GOLD, 2, 3, 6))
	UIKit.place(stake_label, Rect2(428, 548, 86, 56))
	add_child(stake_label)
	var plus := UIKit.button("+", "wood", 26)
	UIKit.place(plus, Rect2(520, 548, 50, 56))
	plus.pressed.connect(func(): _set_stake(stake + 10))
	add_child(plus)
	accept = UIKit.button("", "red", 22)
	UIKit.place(accept, Rect2(590, 548, 330, 56))
	accept.pressed.connect(func(): main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": stake, "level": lv}}))
	add_child(accept)
	_set_stake(stake)
	var back := UIKit.button("MEJOR NO", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 200, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
