extends Control

## La barra de Lucía: la tienda de la noche.
## - Rondas para subir de nivel al Búho, al Cortado y al Chencho.
## - Tres objetos a la venta que cambian cada hora y media (o pagando el cambio).
## - Chupito de orujo: +1 suerte.

const LUCIA_ART := preload("res://assets/concept/lucia_conversation_v1.png")
const SHOT_PRICE := 15

var main: Control
var args: Dictionary
var speech: Label
var dyn: Control

func _ready() -> void:
	add_child(UIKit.texture_rect(LUCIA_ART))
	speech = UIKit.label("", 19, UIKit.PAPER_INK)
	speech.add_theme_stylebox_override("normal", UIKit.box(Color("#efe2c4"), Color("#6b4f30"), 3, 6, 12))
	UIKit.place(speech, Rect2(20, 290, 300, 110))
	speech.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	speech.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(speech)
	speech.text = "¿Qué te pongo, cielo? Una ronda a tiempo vale más que un caballo."
	dyn = Control.new()
	dyn.size = size
	dyn.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dyn)
	var back := UIKit.button("HASTA LUEGO", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 200, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	_build()

var _sig := ""

func refresh() -> void:
	var sig := str([Night.money, Night.shop, Night.luck, Night.trinkets.size(), Night.rounds_today, Night.trinkets_left_today()])
	if sig != _sig and dyn != null:
		_build()

func _build() -> void:
	_sig = str([Night.money, Night.shop, Night.luck, Night.trinkets.size(), Night.rounds_today, Night.trinkets_left_today()])
	for c in dyn.get_children():
		c.queue_free()
	# --- Rondas (columna derecha)
	UIKit.panel(dyn, Rect2(850, 112, 420, 332), Color(0.1, 0.06, 0.03, 0.92), Color("#8a6a3c"), 3)
	var t := UIKit.label("RONDAS · SUBEN DE NIVEL", 22, UIKit.GOLD)
	t.position = Vector2(866, 118)
	dyn.add_child(t)
	var round_limit := UIKit.label("UNA RONDA POR PERSONA Y NOCHE", 14, Color("#d8c69d"), true)
	UIKit.place(round_limit, Rect2(866, 144, 380, 20))
	dyn.add_child(round_limit)
	var y := 170.0
	for who in ["buho", "cortado", "chencho"]:
		var c: Dictionary = Catalog.CHARACTERS[who]
		var data := GameTexts.character_card(who)
		var lv: int = data["level"]
		var price := Night.round_price(who)
		var pic := UIKit.texture_rect(UIKit.portrait(who), Rect2(864, y, 58, 64))
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		dyn.add_child(pic)
		var name_l := UIKit.label("%s · Nv%d%s" % [data["name"], lv, " → Nv%d" % (lv + 1) if lv < 3 else ""], 17, UIKit.CREAM, true)
		UIKit.place(name_l, Rect2(932, y, 224, 26))
		dyn.add_child(name_l)
		var unlock := "NIVEL MÁXIMO"
		if str(data["next"]) != "":
			unlock = "%s  →  %s" % [data["how"], data["next"]]
		var block_reason := GameTexts.round_block_reason(who)
		var unlock_l := UIKit.label(block_reason.to_upper() if block_reason != "" else unlock, 14, Color("#ffad8f") if block_reason != "" else Color("#d8c69d"), true)
		UIKit.place(unlock_l, Rect2(932, y + 32, 320, 30))
		unlock_l.clip_text = true
		dyn.add_child(unlock_l)
		var b := UIKit.button("%d €" % price if price > 0 else "MÁX", "gold", 20)
		UIKit.place(b, Rect2(1164, y, 90, 30))
		b.disabled = not Night.round_available(who) or block_reason != ""
		b.tooltip_text = block_reason if block_reason != "" else "Invitar a %s" % c["name"]
		b.pressed.connect(func():
			if Night.buy_round(who):
				speech.text = ["Marchando una para %s." % c["name"], "%s ya canta. Buena señal." % c["name"]][lv % 2]
			_build())
		dyn.add_child(b)
		y += 86
	# --- Objetos (posavasos)
	UIKit.panel(dyn, Rect2(330, 470, 940, 240), Color(0.1, 0.06, 0.03, 0.94), Color("#8a6a3c"), 3)
	var t2 := UIKit.label("OBJETOS · LLEVAS %d/%d" % [Night.trinkets.size(), Catalog.MAX_TRINKETS], 22, UIKit.GOLD)
	t2.position = Vector2(346, 476)
	dyn.add_child(t2)
	var limits := UIKit.label(GameTexts.shop_limits_line(), 16, Color("#d8c69d"), true)
	UIKit.place(limits, Rect2(686, 480, 350, 22))
	limits.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	dyn.add_child(limits)
	var x := 346.0
	for i in 3:
		var id: String = Night.shop[i]
		var card := Panel.new()
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_theme_stylebox_override("panel", UIKit.box(Color("#e9dcc0") if id != "" else Color("#5a4a38"), Color("#7a6040"), 3, 8))
		UIKit.place(card, Rect2(x, 510, 220, 190))
		dyn.add_child(card)
		if id == "":
			var sold := UIKit.label("AGOTADO", 24, Color("#a89272"))
			UIKit.place(sold, Rect2(x, 590, 220, 30))
			sold.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			dyn.add_child(sold)
		else:
			var tr: Dictionary = Catalog.TRINKETS[id]
			var nm := UIKit.label(tr["name"], 21, UIKit.PAPER_RED)
			UIKit.place(nm, Rect2(x + 10, 516, 200, 28))
			nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			dyn.add_child(nm)
			var tg := UIKit.label(Catalog.GAME_NAMES.get(tr["game"], "Para todo"), 15, Color("#6b5236"))
			UIKit.place(tg, Rect2(x + 10, 542, 200, 20))
			tg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			dyn.add_child(tg)
			var tx := UIKit.label(tr["text"], 16, UIKit.PAPER_INK)
			UIKit.place(tx, Rect2(x + 12, 564, 196, 62))
			tx.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			tx.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			dyn.add_child(tx)
			var block_reason := GameTexts.trinket_block_reason()
			if block_reason == "" and Night.money < int(tr["price"]):
				block_reason = "No te llega"
			var reason_l := UIKit.label(block_reason.to_upper(), 13, UIKit.PAPER_RED)
			UIKit.place(reason_l, Rect2(x + 10, 628, 200, 18))
			reason_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			reason_l.clip_text = true
			dyn.add_child(reason_l)
			var b := UIKit.button("COMPRAR %d €" % tr["price"], "red", 18)
			UIKit.place(b, Rect2(x + 30, 650, 160, 40))
			b.disabled = block_reason != ""
			b.tooltip_text = block_reason if block_reason != "" else "Comprar %s" % tr["name"]
			b.pressed.connect(func():
				if Night.buy_trinket(i):
					speech.text = "Te lo envuelvo. %s, buena elección." % tr["name"]
				_build())
			dyn.add_child(b)
		x += 232
	# Extras
	var shot := UIKit.button("CHUPITO DE ORUJO\n%d € · +1 suerte" % SHOT_PRICE, "paper", 17)
	UIKit.place(shot, Rect2(1044, 516, 210, 80))
	shot.disabled = Night.money < SHOT_PRICE or Night.luck >= Night.max_luck
	shot.tooltip_text = "Suerte al máximo" if Night.luck >= Night.max_luck else ("No te llega" if Night.money < SHOT_PRICE else "+1 suerte")
	shot.pressed.connect(func():
		if Night.spend(SHOT_PRICE):
			Night.add_luck()
			speech.text = "Del pueblo. Si no te da suerte, te quita el frío."
		_build())
	dyn.add_child(shot)
	var reroll := UIKit.button("OTROS OBJETOS\n%d €" % Catalog.REROLL_PRICE, "paper", 17)
	UIKit.place(reroll, Rect2(1044, 606, 210, 80))
	reroll.disabled = Night.money < Catalog.REROLL_PRICE
	reroll.tooltip_text = "No te llega" if reroll.disabled else "Cambiar los tres objetos"
	reroll.pressed.connect(func():
		if Night.reroll_shop():
			speech.text = "Espera, que tengo más cosas en el almacén..."
		_build())
	dyn.add_child(reroll)
