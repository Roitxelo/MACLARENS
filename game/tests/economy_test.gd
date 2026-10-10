extends Node

## Regresión de la economía (T08): pagos, cobro anticipado, racha con tope,
## calcetín, herradura, colocado, seguro del Chencho y perdón de Tino.
## Imprime ECONOMY_TEST_OK si todo cuadra.

var fails: Array = []

func check(cond: bool, what: String) -> void:
	if cond:
		print("  ok  ", what)
	else:
		print("  MAL ", what)
		fails.append(what)

func fresh() -> void:
	Night.new_night(11)
	Night.money = 1000

func _ready() -> void:
	# --- Fútbol: pago y cobro
	fresh()
	check(Night.place_football("match_0", "1", 10), "apuesta de fútbol aceptada")
	var m: Dictionary = Night.football.get_match("match_0")
	var odds: float = m["odds"]["1"]
	var bet: Dictionary = Night.bets[0]
	check(Night.cashout_value(bet) == 9, "cobro anticipado con comisión del 10 %% (cuota sin cambios): %d" % Night.cashout_value(bet))
	Night.levels["buho"] = 2
	check(Night.cashout_value(bet) == 10, "Búho Nv2: cobro sin comisión")
	var sim: MatchSimulator = m["sim"]
	sim.home_score = 2
	sim.away_score = 0
	m["state"] = "done"
	Night._settle_bets()
	check(Night.money == 990 + int(round(10 * odds)), "premio = apuesta × cuota (%d)" % Night.money)
	check(Night.streak == 1, "la victoria inicia la racha")

	# --- Racha: +0,1 por victoria previa, tope x1,5
	fresh()
	var expected := [10, 11, 12, 13, 14, 15, 15, 15]
	var got: Array = []
	for k in expected.size():
		got.append(Night.register_win("horse", 10, 20) - 10)
	check(got == expected, "beneficios con racha %s" % str(got))
	var before_streak := Night.streak
	Night.register_win("cards", 5, 10)
	check(Night.streak == before_streak, "apuestas de menos de 10 € no suman racha")
	Night.register_loss("horse")
	check(Night.streak == 0, "una derrota rompe la racha")
	Night.trinkets.append("calcetin")
	Night.register_win("horse", 10, 20)
	Night.register_win("horse", 10, 20)
	Night.register_loss("horse")
	check(Night.streak == 2, "el calcetín salva la primera derrota")
	Night.register_loss("horse")
	check(Night.streak == 0, "la segunda derrota sí rompe la racha")

	# --- Caballos: herradura y colocado
	fresh()
	Night.trinkets.append("herradura")
	check(Night.place_horse(0, 2, 30), "apuesta a ganador")
	check(not Night.place_horse(0, 3, 10, "place"), "colocado bloqueado sin Cortado Nv3")
	Night.levels["cortado"] = 3
	check(Night.place_horse(0, 3, 10, "place"), "colocado con Cortado Nv3")
	var race: Dictionary = Night.races.races[0]
	race["order"] = [3, 2, 0, 1, 4, 5]
	race["state"] = "done"
	var money_before := Night.money
	Night._settle_bets()
	var place_odds := Night.horse_place_odds(race["horses"][3])
	check(Night.bets[0]["status"] == "refunded" and int(Night.bets[0]["payout"]) == 20, "herradura: 2.º puesto devuelve hasta 20 €")
	check(Night.bets[1]["status"] == "won", "colocado: el 1.º cobra")
	check(Night.money == money_before + 20 + int(round(10 * place_odds)), "dinero tras herradura y colocado (%d)" % Night.money)

	# --- Chencho Nv2: seguro tras un acierto
	fresh()
	Night.levels["chencho"] = 2
	var cards: Control = load("res://ui/minigames/mayor_menor.gd").new()
	cards.size = Vector2(1280, 720)
	add_child(cards)
	await get_tree().process_frame
	cards.stake = 20
	cards._deal()
	cards.current = {"suit": "oros", "value": 1}
	cards.deck = [{"suit": "copas", "value": 2}, {"suit": "bastos", "value": 7}]
	cards._guess(1)   # sale el 7: acierto
	var pot_after_win: int = cards.pot
	var money_mid := Night.money
	cards._guess(1)   # sale el 2: fallo con seguro
	check(pot_after_win > 20, "el acierto multiplica el bote (%d)" % pot_after_win)
	check(Night.money == money_mid + pot_after_win / 2, "el seguro devuelve la mitad del bote")
	check(not Night.pauses.has("minigame"), "el reloj no se queda en pausa tras la mano")
	cards.queue_free()

	# --- Tino: perdón de deuda solo la primera vez en Nv3
	fresh()
	var main = load("res://scenes/night.tscn").instantiate()
	add_child(main)
	await get_tree().process_frame
	Night.new_night(11)
	Night.money = 1000
	for i in 2:
		main.go("billar", {"rival": {"id": "tino", "name": "Tino", "stake": 60, "level": 3}, "autoplay": true})
		var g = main.current
		var t := 0.0
		while g.state != "over" and t < 60.0:
			await get_tree().create_timer(0.2).timeout
			t += 0.2
	check(Night.debt == Night.START_DEBT - 100, "Tino perdona 100 € una sola vez (deuda %d)" % Night.debt)

	print("ECONOMY_TEST_OK" if fails.is_empty() else "ECONOMY_TEST_FAIL %s" % str(fails))
	get_tree().quit()
