extends Control

## Cierre de la noche: Tino viene a cobrar la cuota. Si llegas, pagas y
## pasas a la noche siguiente (dinero, niveles y objetos se conservan).
## Si no llegas, o es la quinta noche, se acaba la campaña.

const END_ART := preload("res://assets/concept/end_of_day_debt_v1.png")

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(END_ART))
	var reason := str(args.get("reason", "closing"))
	var bank := Night.money
	var quota := Night.debt
	var paid := Night.pay_tino()
	var summary := GameTexts.end_summary(bank, quota, paid, reason)
	var last := Night.is_last_night()
	# Reloj del arte: hora real del cierre
	UIKit.panel(self, Rect2(1040, 82, 172, 54), Color("#0d120d"))
	var clock := UIKit.label(Night.clock_text(), 46, Color("#7dff8a"), true)
	UIKit.place(clock, Rect2(1040, 80, 172, 56))
	clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(clock)
	# Hoja de la libreta
	var page := UIKit.panel(self, Rect2(428, 138, 400, 398), Color("#e9dcbc"))
	page.add_theme_stylebox_override("panel", UIKit.box(Color("#e9dcbc"), Color("#b8a27a"), 2, 2))
	var head := UIKit.label(summary["head"], 30, UIKit.PAPER_RED)
	UIKit.place(head, Rect2(440, 146, 380, 40))
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(head)
	var row_y := 192.0
	for row in summary["rows"]:
		var row_label := UIKit.label(str(row[0]), 22, UIKit.PAPER_INK, true)
		UIKit.place(row_label, Rect2(456, row_y, 220, 30))
		add_child(row_label)
		var row_value := UIKit.label(str(row[1]), 22, UIKit.PAPER_INK, true)
		UIKit.place(row_value, Rect2(676, row_y, 124, 30))
		row_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		add_child(row_value)
		row_y += 32
	var today := UIKit.label("%s     Mejor racha: %d" % [summary["today"], Night.best_streak], 18, UIKit.PAPER_INK, true)
	UIKit.place(today, Rect2(456, 324, 344, 30))
	add_child(today)
	var moments: Array = Night.history.filter(func(h): return int(h["delta"]) > 0)
	moments.sort_custom(func(a, b): return int(a["delta"]) > int(b["delta"]))
	var mlines: Array = []
	for mo in moments.slice(0, 3):
		mlines.append("%s  %s (%+d €)" % [mo["time"], mo["text"], mo["delta"]])
	var ml := UIKit.label("\n".join(mlines) if not mlines.is_empty() else "Ni un solo golpe de suerte. Tino lo nota.", 15, Color("#4a3622"))
	UIKit.place(ml, Rect2(452, 378, 366, 70))
	ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(ml)
	var vl := UIKit.label(summary["verdict"], 26, Color("#2f6b2a") if paid else UIKit.PAPER_RED)
	UIKit.place(vl, Rect2(440, 470, 380, 40))
	vl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(vl)
	# Nota de Tino sobre la polaroid
	UIKit.panel(self, Rect2(948, 312, 202, 116), Color("#ece4d2"))
	var ql := UIKit.label(summary["quote"] + "\n— Tino", 18, Color("#2a2a2a"))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.place(ql, Rect2(956, 322, 186, 104))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ql.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(ql)
	# Botones nuevos sobre los impresos
	var go_on := paid and not last
	var again := UIKit.button(summary["button"], "wood", 30)
	UIKit.place(again, Rect2(200, 600, 392, 90))
	again.pressed.connect(func():
		if go_on:
			Night.next_night()
			main.go("bar")
		else:
			main.go("stats"))
	add_child(again)
	var quit := UIKit.button("SALIR DEL BAR", "wood", 30)
	UIKit.place(quit, Rect2(628, 600, 412, 90))
	quit.pressed.connect(func(): get_tree().quit())
	add_child(quit)
	var banner := UIKit.shadow(UIKit.label(summary["banner"], 40, UIKit.GOLD if paid else Color("#ff8a70")))
	UIKit.place(banner, Rect2(0, 20, 1280, 50))
	banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(banner)
