extends Node2D

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")
const PAPER := preload("res://assets/concept/newspaper_resting_v2.png")
const MACHINE := preload("res://assets/concept/betting_machine_interface_v1.png")
const CONTACTS := preload("res://assets/concept/contacts_interface_v1.png")
const LUCIA := preload("res://assets/concept/lucia_conversation_v1.png")
const LIVE_MACHINE := preload("res://assets/concept/live_market_event_v1.png")
const END_DAY := preload("res://assets/concept/end_of_day_debt_v1.png")
const BetManagerScript := preload("res://betting/bet_manager.gd")

enum Step { BAR_START, PAPER_OPEN, CLUE_FOUND, BAR_INFORMED, CONTACTS_OPEN, LUCIA_DIALOGUE, MACHINE_OPEN, MATCH_LIVE, REVEAL, END_DAY }

var step := Step.BAR_START
var canvas: Control
var view: TextureRect
var hint: Label
var tv_state: Label
var tv_state_b: Label
var paper_hotspot: Button
var machine_hotspot: Button
var contacts_hotspot: Button
var lucia_hotspot: Button
var back_button: Button
var relation_line: Line2D
var stake := 10
var betting = BetManagerScript.new()
var match_a: MatchSimulator
var match_b: MatchSimulator
var snapshot_a: MatchSnapshot
var snapshot_b: MatchSnapshot
var match_timer: Timer
var hud: Label
var luck_button: Button
var round_has_bet := false
var selected_match_id := "match_a"
var previous_odds_a := 0.0
var previous_odds_b := 0.0
var contact_clue_known := false
var lucia_trust := 0
var has_investigated := false
var reviewing_end_day := false

func _ready() -> void:
	GameState.reset_run()
	var round_data := RoundSetup.create_default_round(4)
	match_a = round_data["match_a"] as MatchSimulator
	match_b = round_data["match_b"] as MatchSimulator
	snapshot_a = MatchSnapshot.new(match_a.snapshot())
	snapshot_b = MatchSnapshot.new(match_b.snapshot())
	previous_odds_a = snapshot_a.home_odds
	previous_odds_b = snapshot_b.home_odds
	_build_screen()
	GameState.resources_changed.connect(_update_hud)
	_update_hud(GameState.money, GameState.minutes_left, GameState.luck)
	_show_bar_start()

func _build_screen() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	canvas = Control.new()
	canvas.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(canvas)

	view = TextureRect.new()
	view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas.add_child(view)

	# Dos TVs, no una: pilar 6 (simultaneidad visible) exige que ambos
	# partidos permanezcan a la vista, no solo el que lleva la apuesta.
	tv_state = Label.new()
	tv_state.position = Vector2(282, 58)
	tv_state.size = Vector2(220, 108)
	tv_state.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tv_state.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tv_state.add_theme_font_size_override("font_size", 12)
	tv_state.clip_text = true
	tv_state.add_theme_color_override("font_color", Color("#d8f0df"))
	tv_state.add_theme_color_override("font_shadow_color", Color.BLACK)
	tv_state.add_theme_constant_override("shadow_offset_x", 2)
	tv_state.add_theme_constant_override("shadow_offset_y", 2)
	canvas.add_child(tv_state)

	tv_state_b = Label.new()
	tv_state_b.position = Vector2(740, 58)
	tv_state_b.size = Vector2(220, 108)
	tv_state_b.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tv_state_b.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tv_state_b.add_theme_font_size_override("font_size", 12)
	tv_state_b.clip_text = true
	tv_state_b.add_theme_color_override("font_color", Color("#d8f0df"))
	tv_state_b.add_theme_color_override("font_shadow_color", Color.BLACK)
	tv_state_b.add_theme_constant_override("shadow_offset_x", 2)
	tv_state_b.add_theme_constant_override("shadow_offset_y", 2)
	canvas.add_child(tv_state_b)

	hint = Label.new()
	hint.position = Vector2(240, 650)
	hint.size = Vector2(800, 52)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint.add_theme_font_size_override("font_size", 20)
	hint.add_theme_color_override("font_color", Color("#f0dca9"))
	hint.add_theme_color_override("font_shadow_color", Color.BLACK)
	hint.add_theme_constant_override("shadow_offset_x", 2)
	hint.add_theme_constant_override("shadow_offset_y", 2)
	canvas.add_child(hint)

	hud = Label.new()
	hud.position = Vector2(24, 18)
	hud.size = Vector2(500, 48)
	hud.add_theme_font_size_override("font_size", 20)
	hud.add_theme_color_override("font_color", Color("#f0dca9"))
	hud.add_theme_color_override("font_shadow_color", Color.BLACK)
	hud.add_theme_constant_override("shadow_offset_x", 2)
	hud.add_theme_constant_override("shadow_offset_y", 2)
	canvas.add_child(hud)

	luck_button = Button.new()
	luck_button.position = Vector2(1040, 18)
	luck_button.size = Vector2(210, 46)
	luck_button.text = "USAR CORAZONADA ★"
	luck_button.visible = false
	luck_button.pressed.connect(_use_luck)
	canvas.add_child(luck_button)

	paper_hotspot = _hotspot(Rect2(470, 510, 390, 190), "Examinar el periódico")
	paper_hotspot.pressed.connect(_open_paper)
	machine_hotspot = _hotspot(Rect2(980, 255, 285, 355), "Usar la máquina")
	machine_hotspot.pressed.connect(_open_machine)
	contacts_hotspot = _hotspot(Rect2(105, 565, 270, 135), "Consultar contactos")
	contacts_hotspot.pressed.connect(_open_contacts)
	lucia_hotspot = _hotspot(Rect2(520, 205, 310, 250), "Hablar con Lucía")
	lucia_hotspot.pressed.connect(_open_lucia)

	back_button = Button.new()
	back_button.position = Vector2(24, 650)
	back_button.size = Vector2(170, 44)
	back_button.text = "VOLVER AL BAR"
	back_button.visible = false
	luck_button.visible = false
	back_button.pressed.connect(_on_back)
	canvas.add_child(back_button)

func _hotspot(rect: Rect2, tooltip: String) -> Button:
	var button := Button.new()
	button.position = rect.position
	button.size = rect.size
	button.flat = true
	button.modulate = Color(1, 1, 1, 0.02)
	button.tooltip_text = tooltip
	canvas.add_child(button)
	return button

func _show_bar_start() -> void:
	_reset_hint_layout()
	step = Step.BAR_START
	view.texture = BAR
	hud.visible = true
	tv_state.visible = true
	tv_state.text = "%s — %s\nA PUNTO DE EMPEZAR  ·  0'  ·  CUOTA %.2f" % [snapshot_a.home, snapshot_a.away, snapshot_a.home_odds]
	tv_state_b.visible = true
	tv_state_b.text = "Sporting Carbón — Dinamo Rotonda\nA PUNTO DE EMPEZAR  ·  0'  ·  CUOTA %.2f" % snapshot_b.home_odds
	hint.text = "La noche aún no ha empezado. Algo en la mesa llama tu atención."
	paper_hotspot.visible = true
	machine_hotspot.visible = false
	contacts_hotspot.visible = true
	lucia_hotspot.visible = true
	back_button.visible = false

func _open_paper() -> void:
	_reset_hint_layout()
	step = Step.PAPER_OPEN
	_crossfade_to(PAPER)
	hud.visible = true
	tv_state.visible = false
	tv_state_b.visible = false
	paper_hotspot.visible = false
	machine_hotspot.visible = false
	contacts_hotspot.visible = false
	lucia_hotspot.visible = false
	back_button.visible = false
	hint.text = "Selecciona el nombre de Bruno Salas para buscarlo en las otras noticias."
	luck_button.visible = true
	var name_hotspot := _hotspot(Rect2(230, 175, 430, 115), "Bruno Salas")
	name_hotspot.name = "BrunoHotspot"
	name_hotspot.pressed.connect(func():
		name_hotspot.queue_free()
		_reveal_first_relation())

func _reveal_first_relation() -> void:
	step = Step.CLUE_FOUND
	has_investigated = true
	GameState.spend_time(2)
	relation_line = Line2D.new()
	relation_line.width = 5.0
	relation_line.default_color = Color("#9d302b")
	relation_line.points = PackedVector2Array([Vector2(515, 260), Vector2(670, 310), Vector2(850, 245)])
	canvas.add_child(relation_line)
	hint.text = "Bruno fue convocado, pero ayer tenía molestias. El técnico dice que está listo. ¿Dice toda la verdad?"
	await get_tree().create_timer(0.7).timeout
	back_button.visible = true
	luck_button.visible = true

func _return_to_bar() -> void:
	_reset_hint_layout()
	if relation_line != null:
		relation_line.queue_free()
		relation_line = null
	_clear_wager_controls()
	_clear_context_controls()
	step = Step.BAR_INFORMED if has_investigated else Step.BAR_START
	_crossfade_to(BAR)
	hud.visible = true
	tv_state.visible = true
	tv_state.text = "%s — %s\nA PUNTO DE EMPEZAR  ·  0'  ·  CUOTA %.2f" % [snapshot_a.home, snapshot_a.away, snapshot_a.home_odds]
	tv_state_b.visible = true
	tv_state_b.text = "Sporting Carbón — Dinamo Rotonda\nA PUNTO DE EMPEZAR  ·  0'  ·  CUOTA %.2f" % snapshot_b.home_odds
	hint.text = "La cuota sigue quieta. La máquina espera tu decisión." if has_investigated else "Aún necesitas contrastar el periódico antes de apostar."
	back_button.visible = false
	luck_button.visible = false
	machine_hotspot.visible = has_investigated
	paper_hotspot.visible = not has_investigated
	contacts_hotspot.visible = true
	lucia_hotspot.visible = true

func _open_contacts() -> void:
	_reset_hint_layout()
	step = Step.CONTACTS_OPEN
	_crossfade_to(CONTACTS)
	hud.visible = true
	tv_state.visible = false
	tv_state_b.visible = false
	_hide_bar_hotspots()
	back_button.visible = true
	luck_button.visible = false
	hint.text = "Cada llamada cuesta 1 minuto. La fiabilidad orienta, no garantiza."
	var calls := [
		{"name": "CallLucia", "rect": Rect2(520, 125, 410, 170), "contact": "lucia"},
		{"name": "CallBuho", "rect": Rect2(520, 300, 410, 165), "contact": "buho"},
		{"name": "CallTino", "rect": Rect2(520, 480, 410, 165), "contact": "tino"},
	]
	for call in calls:
		var button := _hotspot(call["rect"], "Llamar")
		button.name = call["name"]
		button.pressed.connect(_call_contact.bind(str(call["contact"])))

func _call_contact(contact: String) -> void:
	GameState.spend_time(1)
	contact_clue_known = true
	match contact:
		"lucia": hint.text = "Lucía (fiable): Bruno no entrenó con el grupo."
		"buho": hint.text = "El Búho (irregular): el técnico suele esconder molestias antes de un derbi."
		_: hint.text = "Tino (interesado): asegura que Bruno no termina el partido. Puede estar vendiéndote humo."

func _open_lucia() -> void:
	step = Step.LUCIA_DIALOGUE
	_crossfade_to(LUCIA)
	hud.visible = true
	tv_state.visible = false
	tv_state_b.visible = false
	_hide_bar_hotspots()
	back_button.visible = true
	luck_button.visible = false
	hint.text = "Lucía sabe más de lo que dice. Elige cómo acercarte."
	hint.position = Vector2(315, 515)
	hint.size = Vector2(850, 42)
	hint.add_theme_font_size_override("font_size", 18)
	var ask := _hotspot(Rect2(545, 585, 205, 110), "Preguntar por Bruno")
	ask.name = "AskLucia"
	ask.pressed.connect(_ask_lucia)
	var change := _hotspot(Rect2(755, 585, 205, 110), "Cambiar de tema")
	change.name = "ChangeTopic"
	change.pressed.connect(func(): hint.text = "Hablas del derbi. No ganas información, pero tampoco gastas recursos.")
	var drink := _hotspot(Rect2(965, 585, 250, 110), "Invitar a una copa")
	drink.name = "BuyDrink"
	drink.pressed.connect(_buy_lucia_drink)

func _ask_lucia() -> void:
	GameState.spend_time(1)
	contact_clue_known = true
	lucia_trust += 1
	hint.text = "Lucía confirma: Bruno no entrenó con el grupo. Confianza +1."

func _buy_lucia_drink() -> void:
	if not GameState.spend_money(5):
		hint.text = "No puedes permitirte invitar ahora."
		return
	lucia_trust += 1
	hint.text = "Lucía acepta el gesto. Confianza +1; la información importante aún hay que preguntarla."

func _hide_bar_hotspots() -> void:
	paper_hotspot.visible = false
	machine_hotspot.visible = false
	contacts_hotspot.visible = false
	lucia_hotspot.visible = false

func _clear_context_controls() -> void:
	for node_name in ["CallLucia", "CallBuho", "CallTino", "AskLucia", "ChangeTopic", "BuyDrink", "LiveTopA", "LiveTopB", "LiveTicket", "LiveCaptured", "LiveCurrent", "LiveCashout", "LiveEvent", "Hold", "Cashout", "Tomorrow", "ReviewClues", "EndSummary"]:
		var node := canvas.get_node_or_null(node_name)
		if node != null:
			node.queue_free()

func _open_machine() -> void:
	step = Step.MACHINE_OPEN
	_crossfade_to(LIVE_MACHINE if betting.has_active_bet() else MACHINE)
	hud.visible = false
	tv_state.visible = false
	tv_state_b.visible = false
	_hide_bar_hotspots()
	_clear_context_controls()
	_clear_machine_market_controls()
	if betting.has_active_bet():
		_build_live_market_controls()
		back_button.visible = true
		return
	_build_machine_market_controls()
	if round_has_bet:
		hint.text = betting.ticket_text() + " · No se abren nuevas posiciones durante este partido."
		back_button.visible = true
		return
	var selected := _selected_snapshot()
	hint.text = "Selecciona partido e importe. %s gana @ %.2f" % [selected.home, selected.home_odds]
	back_button.visible = true
	_show_wager_controls()

func _build_live_market_controls() -> void:
	var active := _active_snapshot()
	var captured := float(betting.active_bet["placed_odds"])
	hint.text = "Motivo del cambio: %s" % _odds_reason(active)
	var top_a := _market_label("LiveTopA", Rect2(800, 175, 155, 62))
	top_a.text = "%.2f" % snapshot_a.home_odds
	var top_b := _market_label("LiveTopB", Rect2(800, 265, 155, 62))
	top_b.text = "%.2f" % snapshot_b.home_odds
	var event_label := _market_label("LiveEvent", Rect2(285, 350, 340, 105))
	event_label.add_theme_font_size_override("font_size", 14)
	event_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	event_label.text = "ÚLTIMO EVENTO\n%s" % active.last_event.to_upper()
	var ticket_label := _market_label("LiveTicket", Rect2(255, 485, 370, 82))
	ticket_label.add_theme_font_size_override("font_size", 18)
	ticket_label.text = "TICKET ACTIVO\n%s · %d € @ %.2f" % [active.home, betting.active_bet["stake"], captured]
	var captured_label := _market_label("LiveCaptured", Rect2(650, 355, 150, 75))
	captured_label.text = "CAPTURADA\n%.2f" % captured
	var current_label := _market_label("LiveCurrent", Rect2(815, 355, 150, 75))
	current_label.text = "ACTUAL\n%.2f" % active.home_odds
	var cashout_value := betting.cashout_value(active.home_odds)
	var cashout_label := _market_label("LiveCashout", Rect2(650, 445, 150, 75))
	cashout_label.text = "COBRO\n%d €" % cashout_value
	var hold := Button.new()
	hold.name = "Hold"
	hold.position = Vector2(300, 550)
	hold.size = Vector2(300, 85)
	hold.flat = true
	hold.tooltip_text = "Mantener la apuesta"
	hold.pressed.connect(_on_back)
	canvas.add_child(hold)
	var cashout := Button.new()
	cashout.name = "Cashout"
	cashout.position = Vector2(650, 550)
	cashout.size = Vector2(320, 85)
	cashout.flat = true
	cashout.tooltip_text = "Cobrar %d €" % cashout_value
	cashout.pressed.connect(_cashout)
	canvas.add_child(cashout)

func _odds_reason(snapshot: MatchSnapshot) -> String:
	var previous := previous_odds_a if snapshot.id == snapshot_a.id else previous_odds_b
	if previous <= 0.0 or is_equal_approx(previous, snapshot.home_odds):
		return "Sin variación desde el último intervalo"
	var direction := "subió" if snapshot.home_odds > previous else "bajó"
	return "%s: la cuota %s de %.2f a %.2f" % [snapshot.last_event, direction, previous, snapshot.home_odds]

func _build_machine_market_controls() -> void:
	var market_a := _market_hotspot("MarketA", Rect2(250, 140, 735, 118), snapshot_a.id)
	market_a.tooltip_text = "Seleccionar %s" % snapshot_a.home
	var market_b := _market_hotspot("MarketB", Rect2(250, 265, 735, 112), snapshot_b.id)
	market_b.tooltip_text = "Seleccionar %s" % snapshot_b.home
	var odds_a := _market_label("OddsA", Rect2(825, 185, 140, 52))
	var odds_b := _market_label("OddsB", Rect2(825, 305, 140, 52))
	odds_a.text = "%.2f" % snapshot_a.home_odds
	odds_b.text = "%.2f" % snapshot_b.home_odds
	var ticket := _market_label("TicketState", Rect2(270, 402, 410, 90))
	ticket.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	ticket.text = betting.ticket_text() if betting.has_active_bet() else "SIN TICKET\nSelecciona un partido"
	_refresh_machine_market()

func _market_hotspot(node_name: String, rect: Rect2, match_id: String) -> Button:
	var button := Button.new()
	button.name = node_name
	button.position = rect.position
	button.size = rect.size
	button.flat = true
	button.pressed.connect(func():
		selected_match_id = match_id
		_refresh_machine_market())
	canvas.add_child(button)
	return button

func _market_label(node_name: String, rect: Rect2) -> Label:
	var label := Label.new()
	label.name = node_name
	label.position = rect.position
	label.size = rect.size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color("#f0bd54"))
	var background := StyleBoxFlat.new()
	background.bg_color = Color("#0d2929")
	background.border_color = Color("#397d77")
	background.set_border_width_all(2)
	label.add_theme_stylebox_override("normal", background)
	canvas.add_child(label)
	return label

func _refresh_machine_market() -> void:
	if betting.has_active_bet():
		selected_match_id = str(betting.active_bet["match_id"])
	var selected := _selected_snapshot()
	var ticket := canvas.get_node_or_null("TicketState") as Label
	if ticket != null:
		ticket.text = betting.ticket_text() if betting.has_active_bet() else "SELECCIÓN\n%s gana @ %.2f" % [selected.home, selected.home_odds]
	for entry in [{"name": "MarketA", "id": snapshot_a.id}, {"name": "MarketB", "id": snapshot_b.id}]:
		var button := canvas.get_node_or_null(entry["name"]) as Button
		if button != null:
			button.disabled = betting.has_active_bet() or round_has_bet
			button.modulate = Color(1.0, 0.78, 0.35, 0.18) if entry["id"] == selected_match_id else Color(1, 1, 1, 0.02)

func _selected_snapshot() -> MatchSnapshot:
	return snapshot_a if selected_match_id == snapshot_a.id else snapshot_b

func _active_snapshot() -> MatchSnapshot:
	if not betting.has_active_bet():
		return _selected_snapshot()
	return snapshot_a if betting.active_bet["match_id"] == snapshot_a.id else snapshot_b

func _clear_machine_market_controls() -> void:
	for node_name in ["MarketA", "MarketB", "OddsA", "OddsB", "TicketState"]:
		var node := canvas.get_node_or_null(node_name)
		if node != null: node.queue_free()

## Construye los controles de importe/confirmar. Separado de _open_machine()
## para poder reconstruirlos si _confirm_bet() falla (antes se perdían y
## dejaban al jugador sin forma de volver a intentarlo).
func _show_wager_controls() -> void:
	var minus := Button.new()
	minus.name = "StakeMinus"
	minus.position = Vector2(700, 410)
	minus.size = Vector2(70, 58)
	minus.text = ""
	minus.flat = true
	minus.tooltip_text = "Reducir importe"
	minus.pressed.connect(func(): stake = maxi(5, stake - 5); _update_stake())
	canvas.add_child(minus)
	var amount := Label.new()
	amount.name = "StakeAmount"
	amount.position = Vector2(775, 410)
	amount.size = Vector2(150, 58)
	amount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	amount.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	amount.add_theme_font_size_override("font_size", 30)
	amount.add_theme_color_override("font_color", Color("#f0bd54"))
	var amount_background := StyleBoxFlat.new()
	amount_background.bg_color = Color("#102d2c")
	amount_background.border_color = Color("#d39b3d")
	amount_background.set_border_width_all(2)
	amount.add_theme_stylebox_override("normal", amount_background)
	canvas.add_child(amount)
	var plus := Button.new()
	plus.name = "StakePlus"
	plus.position = Vector2(930, 410)
	plus.size = Vector2(70, 58)
	plus.text = ""
	plus.flat = true
	plus.tooltip_text = "Aumentar importe"
	plus.pressed.connect(func(): stake = mini(50, stake + 5); _update_stake())
	canvas.add_child(plus)
	var confirm := Button.new()
	confirm.name = "ConfirmBet"
	confirm.position = Vector2(250, 525)
	confirm.size = Vector2(300, 82)
	confirm.text = ""
	confirm.flat = true
	confirm.tooltip_text = "Confirmar apuesta"
	confirm.pressed.connect(_confirm_bet)
	canvas.add_child(confirm)
	_update_stake()

func _update_stake() -> void:
	var amount := canvas.get_node_or_null("StakeAmount") as Label
	if amount != null:
		amount.text = "%d €" % stake

## Libera los controles de importe. Necesario tanto al confirmar una apuesta
## como al volver al bar sin apostar — si no, quedan botones invisibles vivos
## sobre la siguiente pantalla (uno de ellos se solapa con el foco del
## periódico y podría disparar una apuesta con un clic pensado para otra cosa).
func _clear_wager_controls() -> void:
	for node_name in ["StakeMinus", "StakeAmount", "StakePlus", "ConfirmBet"]:
		var node := canvas.get_node_or_null(node_name)
		if node != null: node.queue_free()

func _confirm_bet() -> void:
	_clear_wager_controls()
	var selected := _selected_snapshot()
	if not betting.place_home_win(selected, stake):
		hint.text = "No hay dinero suficiente para esa apuesta."
		_show_wager_controls()
		return
	round_has_bet = true
	step = Step.MATCH_LIVE
	_clear_machine_market_controls()
	_crossfade_to(BAR)
	tv_state.visible = true
	tv_state.text = "¡EMPIEZA EL PARTIDO!\n%s 0 — 0 %s  ·  0'  ·  CUOTA %.2f" % [snapshot_a.home, snapshot_a.away, snapshot_a.home_odds]
	tv_state_b.visible = true
	tv_state_b.text = "Sporting Carbón — Dinamo Rotonda\n0 — 0  ·  1'  ·  CUOTA %.2f" % snapshot_b.home_odds
	hint.text = betting.ticket_text()
	machine_hotspot.visible = true
	match_timer = Timer.new()
	match_timer.wait_time = 1.5
	match_timer.timeout.connect(_advance_matches)
	add_child(match_timer)
	match_timer.start()

func _advance_matches() -> void:
	previous_odds_a = snapshot_a.home_odds
	previous_odds_b = snapshot_b.home_odds
	var event_a := match_a.advance_interval()
	var event_b := match_b.advance_interval()
	snapshot_a = MatchSnapshot.new(match_a.snapshot())
	snapshot_b = MatchSnapshot.new(match_b.snapshot())
	GameState.spend_time(1)
	step = Step.REVEAL if event_a["revealed_fact"] else Step.MATCH_LIVE
	tv_state.text = "%s\n%d — %d  ·  %d'  ·  CUOTA %.2f" % [
		snapshot_a.last_event.to_upper(), snapshot_a.home_score, snapshot_a.away_score,
		snapshot_a.minute, snapshot_a.home_odds]
	tv_state_b.text = "%s\n%d — %d  ·  %d'  ·  CUOTA %.2f" % [
		snapshot_b.last_event.to_upper(), snapshot_b.home_score, snapshot_b.away_score,
		snapshot_b.minute, snapshot_b.home_odds]
	if event_a["revealed_fact"]:
		hint.text = "La casa ya ha visto la molestia. Tu apuesta sigue abierta: mantén o cobra."

	# La cuota mostrada en la máquina no debía quedarse congelada mientras
	# el jugador se queda mirando esa pantalla con una posición abierta.
	var cashout_node := canvas.get_node_or_null("Cashout") as Button
	if cashout_node != null and betting.has_active_bet():
		_refresh_live_market_controls()
	var odds_a := canvas.get_node_or_null("OddsA") as Label
	var odds_b := canvas.get_node_or_null("OddsB") as Label
	if odds_a != null: odds_a.text = "%.2f" % snapshot_a.home_odds
	if odds_b != null: odds_b.text = "%.2f" % snapshot_b.home_odds

	var active_finished := false
	if betting.has_active_bet():
		active_finished = match_a.finished if betting.active_bet["match_id"] == snapshot_a.id else match_b.finished
	if betting.has_active_bet() and active_finished:
		if cashout_node != null:
			cashout_node.queue_free()
		var payout: int = betting.resolve(_active_snapshot())
		hint.text = betting.last_result + (" · +%d €" % payout if payout > 0 else "")
	if match_a.finished and match_b.finished:
		match_timer.stop()
		machine_hotspot.visible = false
		await get_tree().create_timer(0.6).timeout
		_show_end_day()

func _refresh_live_market_controls() -> void:
	if not betting.has_active_bet():
		return
	var active := _active_snapshot()
	var captured := float(betting.active_bet["placed_odds"])
	var event_label := canvas.get_node_or_null("LiveEvent") as Label
	if event_label != null:
		event_label.text = "ÚLTIMO EVENTO\n%s" % active.last_event.to_upper()
	var current_label := canvas.get_node_or_null("LiveCurrent") as Label
	if current_label != null:
		current_label.text = "ACTUAL\n%.2f" % active.home_odds
	var cashout_label := canvas.get_node_or_null("LiveCashout") as Label
	if cashout_label != null:
		cashout_label.text = "COBRO\n%d €" % betting.cashout_value(active.home_odds)
	var top_a := canvas.get_node_or_null("LiveTopA") as Label
	if top_a != null: top_a.text = "%.2f" % snapshot_a.home_odds
	var top_b := canvas.get_node_or_null("LiveTopB") as Label
	if top_b != null: top_b.text = "%.2f" % snapshot_b.home_odds
	hint.text = "Motivo del cambio: %s" % _odds_reason(active)

func _cashout() -> void:
	var value: int = betting.cashout(_active_snapshot().home_odds)
	var cashout_node := canvas.get_node_or_null("Cashout")
	if cashout_node != null: cashout_node.queue_free()
	hint.text = "Cobro anticipado aceptado: %d €. El partido continúa." % value
	_return_to_live_bar()

func _return_to_live_bar() -> void:
	_clear_context_controls()
	_clear_machine_market_controls()
	_crossfade_to(BAR)
	hud.visible = true
	back_button.visible = false
	tv_state.visible = true
	tv_state_b.visible = true
	machine_hotspot.visible = true
	contacts_hotspot.visible = true
	lucia_hotspot.visible = true

func _show_end_day() -> void:
	step = Step.END_DAY
	_clear_context_controls()
	_clear_machine_market_controls()
	_clear_wager_controls()
	_crossfade_to(END_DAY)
	hud.visible = false
	tv_state.visible = false
	tv_state_b.visible = false
	_hide_bar_hotspots()
	back_button.visible = false
	luck_button.visible = false
	hint.position = Vector2(260, 545)
	hint.size = Vector2(760, 42)
	hint.add_theme_font_size_override("font_size", 18)
	var gain := GameState.money - GameState.day_start_money
	var summary := _market_label("EndSummary", Rect2(410, 145, 430, 360))
	summary.add_theme_font_size_override("font_size", 28)
	summary.text = "CIERRE DEL DÍA\n\nBANCA        %d €\nDEUDA        %d €\nQUEDAN       %d DÍAS\n\nHOY          %+d €" % [GameState.money, GameState.debt_target, GameState.days_left, gain]
	var tomorrow := Button.new()
	tomorrow.name = "Tomorrow"
	tomorrow.position = Vector2(205, 600)
	tomorrow.size = Vector2(420, 90)
	tomorrow.flat = true
	tomorrow.tooltip_text = "Continuar mañana"
	tomorrow.pressed.connect(_start_next_day)
	canvas.add_child(tomorrow)
	var review := Button.new()
	review.name = "ReviewClues"
	review.position = Vector2(640, 600)
	review.size = Vector2(430, 90)
	review.flat = true
	review.tooltip_text = "Revisar pistas"
	review.pressed.connect(_review_end_clues)
	canvas.add_child(review)
	hint.text = "Objetivo: alcanzar %d € antes de agotar los días." % GameState.debt_target

func _reset_hint_layout() -> void:
	hint.position = Vector2(240, 650)
	hint.size = Vector2(800, 52)
	hint.add_theme_font_size_override("font_size", 20)

func _review_end_clues() -> void:
	reviewing_end_day = true
	_open_paper()

func _start_next_day() -> void:
	_clear_context_controls()
	GameState.start_next_day()
	var round_data := RoundSetup.create_default_round(4 + (5 - GameState.days_left))
	match_a = round_data["match_a"] as MatchSimulator
	match_b = round_data["match_b"] as MatchSimulator
	snapshot_a = MatchSnapshot.new(match_a.snapshot())
	snapshot_b = MatchSnapshot.new(match_b.snapshot())
	previous_odds_a = snapshot_a.home_odds
	previous_odds_b = snapshot_b.home_odds
	betting = BetManagerScript.new()
	round_has_bet = false
	selected_match_id = snapshot_a.id
	contact_clue_known = false
	has_investigated = false
	reviewing_end_day = false
	if match_timer != null:
		match_timer.queue_free()
		match_timer = null
	_show_bar_start()

func _on_back() -> void:
	_clear_machine_market_controls()
	if reviewing_end_day:
		reviewing_end_day = false
		_show_end_day()
		return
	if round_has_bet:
		var cashout_node := canvas.get_node_or_null("Cashout")
		if cashout_node != null: cashout_node.queue_free()
		_return_to_live_bar()
	else:
		_return_to_bar()

func _use_luck() -> void:
	if not GameState.spend_luck():
		hint.text = "No te quedan corazonadas esta noche."
		return
	GameState.spend_time(1)
	hint.text = "Corazonada: una convocatoria confirma que juega, no que esté al cien por cien."

func _update_hud(money: int, minutes_left: int, luck: int) -> void:
	hud.text = "DINERO  %d €    CIERRE  %02d:%02d    SUERTE  %s" % [
		money, minutes_left / 60, minutes_left % 60, "★".repeat(luck)]

func _crossfade_to(texture: Texture2D) -> void:
	var tween := create_tween()
	tween.tween_property(view, "modulate:a", 0.15, 0.16)
	tween.tween_callback(func(): view.texture = texture)
	tween.tween_property(view, "modulate:a", 1.0, 0.22)
