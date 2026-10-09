extends Node

func _ready() -> void:
	var scene = load("res://scenes/main_bar.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame

	# Los contactos son accesibles desde el bar, cuestan tiempo y no
	# desbloquean por sí solos la apuesta: todavía hay que contrastar.
	scene._open_contacts()
	assert(scene.step == scene.Step.CONTACTS_OPEN)
	var time_before_call: int = GameState.minutes_left
	scene._call_contact("lucia")
	assert(GameState.minutes_left == time_before_call - 1)
	assert(scene.contact_clue_known)
	scene._on_back()
	assert(scene.step == scene.Step.BAR_START)
	assert(not scene.machine_hotspot.visible)

	# Lucía es una fuente funcional con confianza y coste económico opcional.
	scene._open_lucia()
	var money_before_drink: int = GameState.money
	scene._buy_lucia_drink()
	assert(GameState.money == money_before_drink - 5)
	assert(scene.lucia_trust == 1)
	scene._ask_lucia()
	assert(scene.lucia_trust == 2)
	scene._on_back()

	# Tras contrastar, la apuesta abre el estado específico de mercado vivo.
	scene._open_paper()
	scene._reveal_first_relation()
	await get_tree().create_timer(0.8).timeout
	scene._return_to_bar()
	scene._open_machine()
	scene._confirm_bet()
	await get_tree().create_timer(1.7).timeout
	scene._open_machine()
	await get_tree().create_timer(0.5).timeout
	assert(scene.view.texture == scene.LIVE_MACHINE)
	assert(scene.canvas.get_node_or_null("LiveCaptured") != null)
	assert(scene.canvas.get_node_or_null("LiveCurrent") != null)
	assert(scene.canvas.get_node_or_null("LiveEvent") != null)
	assert(scene.hint.text.contains("Motivo del cambio"))
	var live_ticket := scene.canvas.get_node("LiveTicket") as Label
	assert(live_ticket.text.contains("%.2f" % float(scene.betting.active_bet["placed_odds"])))

	# El cierre usa estado real y continuar conserva la banca.
	scene.match_timer.stop()
	var money_at_close: int = GameState.money
	scene._show_end_day()
	assert(scene.step == scene.Step.END_DAY)
	var summary := scene.canvas.get_node("EndSummary") as Label
	assert(summary.text.contains("BANCA"))
	assert(summary.text.contains(str(GameState.debt_target)))
	scene._start_next_day()
	assert(scene.step == scene.Step.BAR_START)
	assert(GameState.days_left == 4)
	assert(GameState.money == money_at_close)
	assert(GameState.minutes_left == 180)

	print("EXPANDED_SCREENS_OK")
	get_tree().quit()
