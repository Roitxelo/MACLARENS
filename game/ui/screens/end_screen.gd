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
	var last := Night.is_last_night()
	var night_no := Night.night_index + 1
	# Reloj del arte: hora real del cierre
	UIKit.panel(self, Rect2(1040, 82, 172, 54), Color("#0d120d"))
	var clock := UIKit.label(Night.clock_text(), 46, Color("#7dff8a"), true)
	UIKit.place(clock, Rect2(1040, 80, 172, 56))
	clock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(clock)
	# Hoja de la libreta
	var page := UIKit.panel(self, Rect2(428, 138, 400, 398), Color("#e9dcbc"))
	page.add_theme_stylebox_override("panel", UIKit.box(Color("#e9dcbc"), Color("#b8a27a"), 2, 2))
	var head := UIKit.label("NOCHE %d DE %d" % [night_no, Night.NIGHTS], 30, UIKit.PAPER_RED)
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
	var body := "LLEGASTE CON   %d €\nTINO COBRA     %d €\nTE QUEDAN      %d €\n\nGanado hoy     %+d €\nMejor racha      %d" % [Night.night_start_money, quota, Night.money if paid else bank, bank - Night.night_start_money, Night.best_streak]
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
	if paid and last:
		verdict = "¡LIBRE! Tino cobra lo último."
	elif paid:
		verdict = "PAGADO. Mañana: %d €." % Night.QUOTAS[Night.night_index + 1]
	elif reason == "broke":
		verdict = "Sin blanca antes de las 02:00."
	else:
		verdict = "Faltan %d €." % (quota - bank)
	var vl := UIKit.label(verdict, 26, Color("#2f6b2a") if paid else UIKit.PAPER_RED)
	UIKit.place(vl, Rect2(440, 470, 380, 40))
	vl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(vl)
	# Nota de Tino sobre la polaroid
	UIKit.panel(self, Rect2(948, 312, 202, 116), Color("#ece4d2"))
	var quote := "Tranquilo. Me quedo la bici, la tele y tu dignidad."
	if paid and last:
		quote = "Cuenta saldada. Ha sido un placer... casi siempre."
	elif paid:
		quote = "Hoy cumples. Mañana vuelvo, y traigo la libreta."
	var ql := UIKit.label(quote + "\n— Tino", 18, Color("#2a2a2a"))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	UIKit.place(ql, Rect2(956, 322, 186, 104))
	ql.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ql.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(ql)
	# Botones nuevos sobre los impresos
	var go_on := paid and not last
	var again := UIKit.button("SIGUIENTE NOCHE" if go_on else "EMPEZAR DE NUEVO", "wood", 30)
	UIKit.place(again, Rect2(200, 600, 392, 90))
	again.pressed.connect(func():
		if go_on:
			Night.next_night()
			main.go("bar")
		else:
			Night.new_campaign()
			main.go("title"))
	add_child(again)
	var quit := UIKit.button("SALIR DEL BAR", "wood", 30)
	UIKit.place(quit, Rect2(628, 600, 412, 90))
	quit.pressed.connect(func(): get_tree().quit())
	add_child(quit)
	var title := "TINO NO ESTÁ CONTENTO"
	if paid:
		title = "¡HAS SALDADO LA DEUDA!" if last else "TINO COBRA. SIGUES VIVO."
	var banner := UIKit.shadow(UIKit.label(title, 40, UIKit.GOLD if paid else Color("#ff8a70")))
	UIKit.place(banner, Rect2(0, 20, 1280, 50))
	banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(banner)
