extends Node

## C03 — Regresión de la campaña de 5 noches: cuotas, pago a Tino, qué se
## conserva entre noches, que cada noche sea distinta y que la quinta cierre.
## Imprime CAMPAIGN_TEST_OK si todo cuadra.

var fails: Array = []

func check(cond: bool, what: String) -> void:
	print(("  ok  " if cond else "  MAL ") + what)
	if not cond:
		fails.append(what)

func _ready() -> void:
	Night.new_campaign(21)
	check(Night.night_index == 0 and Night.money == Night.START_MONEY, "empieza en la noche 1 con el dinero inicial")
	check(Night.debt == Night.QUOTAS[0], "la cuota de la noche 1 es %d €" % Night.QUOTAS[0])
	var first_kickoffs: Array = Night.kickoffs.duplicate()
	var first_teams: Array = Night.football.matches.map(func(m): return "%s-%s" % [m["home_id"], m["away_id"]])

	# Mejoras que deben sobrevivir a la noche
	Night.levels["cortado"] = 2
	Night.trinkets.append("tiza")
	Night.max_luck = Night.BASE_LUCK + 1
	Night.luck = 0
	Night.streak = 3
	Night.billar_played = 3
	Night.money = 260
	check(Night.pay_tino(), "con 260 € se paga la cuota de 100 €")
	check(Night.money == 160, "tras pagar quedan 160 € (%d)" % Night.money)
	Night.next_night()
	check(Night.night_index == 1 and Night.debt == Night.QUOTAS[1], "noche 2 con cuota %d €" % Night.QUOTAS[1])
	check(Night.money == 160 and Night.night_start_money == 160, "el dinero pasa a la noche siguiente")
	check(Night.level("cortado") == 2 and Night.has_trinket("tiza"), "niveles y objetos se conservan")
	check(Night.luck == Night.max_luck and Night.max_luck == Night.BASE_LUCK + 1, "la suerte se rellena hasta el máximo ganado")
	check(Night.streak == 0 and Night.bets.is_empty() and Night.billar_left() == Catalog.TINO_SERIES, "racha, boletos y series de Tino se reinician")
	check(Night.clock == 0.0 and not Night.over, "el reloj vuelve a las 18:00")
	var second_teams: Array = Night.football.matches.map(func(m): return "%s-%s" % [m["home_id"], m["away_id"]])
	check(Night.kickoffs != first_kickoffs or second_teams != first_teams, "la noche 2 no repite partidos y horarios")

	# No llegar a la cuota
	Night.money = Night.debt - 1
	check(not Night.pay_tino() and Night.money == Night.debt - 1, "sin llegar no se cobra nada")

	# Rebaja de Tino: siempre a la última noche
	Night.money = 10000
	Night.reduce_debt(100, "prueba")
	check(Night.debt == Night.QUOTAS[1], "la rebaja no toca la cuota de hoy")
	for k in range(2, Night.NIGHTS):
		check(Night.pay_tino(), "paga la noche %d" % k)
		Night.next_night()
	check(Night.is_last_night() and Night.debt == Night.QUOTAS[Night.NIGHTS - 1] - 100, "la quinta noche cobra %d € (con la rebaja)" % Night.debt)
	Night.next_night()
	check(Night.night_index == Night.NIGHTS - 1, "no hay sexta noche")

	# Variedad: en 20 campañas, los partidos cambian de hora y McLarens de franja
	var slots := {}
	var times := {}
	for c in 20:
		Night.new_campaign(500 + c)
		for m in Night.football.matches:
			if m["home_id"] == "mclarens_fc" or m["away_id"] == "mclarens_fc":
				slots[int(m["index"])] = true
			times[int(m["kickoff"])] = true
	check(slots.size() == 2, "McLarens FC juega en las dos franjas según la noche")
	check(times.size() >= 6, "horarios variados (%d distintos)" % times.size())

	# Textos del cierre (C04)
	Night.new_campaign(7)
	var t := GameTexts.end_summary(130, 100, true, "closing")
	check(t["rows"][3][1] == "30 €" and t["button"] == "SIGUIENTE NOCHE", "cierre: te quedan 30 € y pasas de noche")
	check(GameTexts.end_summary(80, 100, false, "closing")["verdict"] == "Faltan 20 €.", "cierre: faltan 20 €")
	check(GameTexts.tonight_lines().size() == 3, "periódico: tres líneas de la noche")

	# Textos cortos (C05, C07, T04)
	check(GameTexts.TITLE_LINES.size() == 3, "portada: tres líneas")
	for id in Catalog.TRINKETS:
		check(GameTexts.TRINKET_SHORT.has(id) and str(GameTexts.TRINKET_SHORT[id]).split(" ").size() <= 6, "objeto %s con efecto corto" % id)
	for who in ["buho", "cortado", "chencho", "tino"]:
		check(str(GameTexts.character_card(who)["now"]) != "", "ficha de %s" % who)
	check(GameTexts.HELP.has("pressure") and GameTexts.HELP.has("billar"), "ayudas de presión y billar")

	# Estadísticas de campaña (pantalla final)
	Night.new_campaign(9)
	Night.money = 500
	Night.register_win("billar", 20, 40)
	Night.register_loss("cards")
	Night.log_moment("Billar: prueba", 20)
	check(Night.pay_tino() and int(Night.stats["nights_paid"]) == 1 and int(Night.stats["paid_total"]) == Night.QUOTAS[0], "las estadísticas cuentan noches y pagos")
	check(Night.stats["games"]["billar"][0] == 1 and Night.stats["games"]["cards"][1] == 1, "cuentan victorias y derrotas por juego")
	var cs := GameTexts.campaign_summary()
	check(cs["games"].size() == 4 and not cs["won"] and str(cs["best"]).contains("Billar"), "resumen final listo para la pantalla")

	print("CAMPAIGN_TEST_OK" if fails.is_empty() else "CAMPAIGN_TEST_FAIL %s" % str(fails))
	get_tree().quit()
