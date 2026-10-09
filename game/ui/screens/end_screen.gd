extends Control

## Cierre: Tino viene a cobrar. Se compara la banca con la deuda.

const END_ART := preload("res://assets/concept/end_of_day_debt_v1.png")

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(END_ART))
	var paid := Night.money >= Night.debt
	var reason := str(args.get("reason", "closing"))
	# Reloj del arte: hora real del cierre
	UIKit.panel(self, Rect2(1040, 82, 172, 54), Color("#0d120d"))
	var clock := UIKit.label(Night.clock_text(), 46, Color("#7dff8a"), true)
	UIKit.place(clock, Rect2(1040, 80, 172, 56))
	clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(clock)
	# Hoja de la libreta
	var page := UIKit.panel(self, Rect2(428, 138, 400, 398), Color("#e9dcbc"))
	page.add_theme_stylebox_override("panel", UIKit.box(Color("#e9dcbc"), Color("#b8a27a"), 2, 2))
	var head := UIKit.label("CUENTAS CON TINO", 30, UIKit.PAPER_RED)
	UIKit.place(head, Rect2(440, 146, 380, 40))
	head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(head)
	var won := 0
	var lost := 0
	for b in Night.bets:
		if b["status"] == "won" or b["status"] == "cashed":
			won += 1
		elif b["status"] == "lost":
			lost += 1
	var body := "BANCA          %d €\nDEUDA          %d €\nRESULTADO      %+d €\n\nMejor racha      %d\nObjetos          %d" % [Night.money, Night.debt, Night.money - Night.START_MONEY, Night.best_streak, Night.trinkets.size()]
	var bl := UIKit.label(body, 26, UIKit.PAPER_INK, true)
	UIKit.place(bl, Rect2(456, 192, 360, 180))
	add_child(bl)
	var moments: Array = Night.history.filter(func(h): return int(h["delta"]) > 0)
	moments.sort_custom(func(a, b): return int(a["delta"]) > int(b["delta"]))
	var mlines: Array = []
	for mo in moments.slice(0, 3):
		mlines.append("%s  %s (%+d €)" % [mo["time"], mo["text"], mo["delta"]])
	var ml := UIKit.label("\n".join(mlines) if not mlines.is_empty() else "Ni un solo golpe de suerte. Tino lo nota.", 15, Color("#4a3622"))
	UIKit.place(ml, Rect2(452, 378, 366, 70))
	ml.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(ml)
	var verdict := ""
	if paid:
		verdict = "PAGADO. Te sobran %d €." % (Night.money - Night.debt)
	elif reason == "broke":
		verdict = "Sin blanca antes de las 02:00."
	else:
		verdict = "Faltan %d €." % (Night.debt - Night.money)
	var vl := UIKit.label(verdict, 26, Color("#2f6b2a") if paid else UIKit.PAPER_RED)
	UIKit.place(vl, Rect2(440, 470, 380, 40))
	vl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(vl)
	# Nota de Tino sobre la polaroid
	UIKit.panel(self, Rect2(948, 312, 202, 116), Color("#ece4d2"))
	var quote := "Un placer hacer negocios contigo. ¿Repetimos el viernes?" if paid else "Tranquilo. Me quedo la bici, la tele y tu dignidad."
	var ql := UIKit.label(quote + "\n— Tino", 18, Color("#2a2a2a"))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.place(ql, Rect2(956, 322, 186, 104))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ql.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(ql)
	# Botones nuevos sobre los impresos
	var again := UIKit.button("OTRA NOCHE", "wood", 30)
	UIKit.place(again, Rect2(200, 600, 392, 90))
	again.pressed.connect(func():
		Night.new_night()
		main.go("title"))
	add_child(again)
	var quit := UIKit.button("SALIR DEL BAR", "wood", 30)
	UIKit.place(quit, Rect2(628, 600, 412, 90))
	quit.pressed.connect(func(): get_tree().quit())
	add_child(quit)
	var banner := UIKit.shadow(UIKit.label("¡HAS SALDADO LA DEUDA!" if paid else "TINO NO ESTÁ CONTENTO", 40, UIKit.GOLD if paid else Color("#ff8a70")))
	UIKit.place(banner, Rect2(0, 20, 1280, 50))
	banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(banner)
