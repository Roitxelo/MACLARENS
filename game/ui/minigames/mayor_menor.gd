extends Control

## "¿Mayor o menor?" con El Chencho, el borracho de la mesa del rincón.
## Baraja española. Cada acierto multiplica el bote; puedes plantarte y
## cobrar o seguir arriesgando. Si sale la misma carta, no pasa nada.

const MINUTES_COST := 5
const MAX_STEPS := 6
const SUITS := ["oros", "copas", "espadas", "bastos"]
const VALUES := [1, 2, 3, 4, 5, 6, 7, 10, 11, 12]

var main: Control
var args: Dictionary
var stake := 10
var pot := 0
var steps := 0
var deck: Array = []
var current: Dictionary = {}
var previous: Dictionary = {}
var peek := false
var playing := false
var rng := RandomNumberGenerator.new()
var speech: Label
var pot_label: Label
var stake_row: Control
var play_row: Control
var stake_label: Label
var higher_btn: Button
var lower_btn: Button
var cash_btn: Button
var hunch_btn: Button
var deal_btn: Button
var odds_label: Label

func _ready() -> void:
	rng.randomize()
	var pic := UIKit.texture_rect(UIKit.portrait("borracho"), Rect2(60, 90, 230, 230))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var name_l := UIKit.shadow(UIKit.label("EL CHENCHO", 28, UIKit.GOLD))
	UIKit.place(name_l, Rect2(60, 322, 230, 34))
	name_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(name_l)
	speech = UIKit.label("", 19, UIKit.PAPER_INK)
	speech.add_theme_stylebox_override("normal", UIKit.box(Color("#efe2c4"), Color("#6b4f30"), 3, 6, 12))
	UIKit.place(speech, Rect2(40, 366, 280, 150))
	speech.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	speech.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(speech)
	var title := UIKit.shadow(UIKit.label("¿MAYOR O MENOR?", 40, UIKit.CREAM))
	UIKit.place(title, Rect2(360, 70, 880, 50))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var rules := UIKit.shadow(UIKit.label("Adivina si la siguiente carta es mayor o menor. Cada acierto multiplica el bote. Plántate cuando quieras. Sota, caballo y rey valen 10, 11 y 12.", 17, Color("#d8e8d0")))
	UIKit.place(rules, Rect2(380, 118, 840, 50))
	rules.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rules.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(rules)
	pot_label = UIKit.shadow(UIKit.label("", 30, UIKit.GOLD))
	UIKit.place(pot_label, Rect2(360, 496, 880, 36))
	pot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(pot_label)
	odds_label = UIKit.shadow(UIKit.label("", 19, Color("#d8e8d0")))
	UIKit.place(odds_label, Rect2(360, 530, 880, 26))
	odds_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(odds_label)

	stake_row = Control.new()
	stake_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stake_row.size = size
	add_child(stake_row)
	var minus := UIKit.button("-", "wood", 30)
	UIKit.place(minus, Rect2(560, 560, 56, 56))
	minus.pressed.connect(func(): _change_stake(-5))
	stake_row.add_child(minus)
	stake_label = UIKit.label("", 32, UIKit.GOLD)
	stake_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stake_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stake_label.add_theme_stylebox_override("normal", UIKit.box(Color("#13301b"), UIKit.GOLD, 2, 3, 6))
	UIKit.place(stake_label, Rect2(622, 560, 110, 56))
	stake_row.add_child(stake_label)
	var plus := UIKit.button("+", "wood", 30)
	UIKit.place(plus, Rect2(738, 560, 56, 56))
	plus.pressed.connect(func(): _change_stake(5))
	stake_row.add_child(plus)
	deal_btn = UIKit.button("REPARTIR", "red", 26)
	UIKit.place(deal_btn, Rect2(810, 560, 200, 56))
	deal_btn.pressed.connect(_deal)
	stake_row.add_child(deal_btn)

	play_row = Control.new()
	play_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	play_row.size = size
	add_child(play_row)
	higher_btn = UIKit.button("MAYOR", "green", 28)
	UIKit.place(higher_btn, Rect2(440, 560, 200, 60))
	higher_btn.pressed.connect(_guess.bind(1))
	play_row.add_child(higher_btn)
	lower_btn = UIKit.button("MENOR", "red", 28)
	UIKit.place(lower_btn, Rect2(660, 560, 200, 60))
	lower_btn.pressed.connect(_guess.bind(-1))
	play_row.add_child(lower_btn)
	cash_btn = UIKit.button("", "gold", 22)
	UIKit.place(cash_btn, Rect2(880, 560, 240, 60))
	cash_btn.pressed.connect(_cash)
	play_row.add_child(cash_btn)
	hunch_btn = UIKit.button("CORAZONADA: MIRAR CARTA", "gold", 16)
	UIKit.place(hunch_btn, Rect2(560, 632, 300, 40))
	hunch_btn.tooltip_text = "Gasta 1 de suerte para ver de reojo la siguiente carta"
	hunch_btn.pressed.connect(_hunch)
	play_row.add_child(hunch_btn)

	var back := UIKit.button("LEVANTARSE", "wood", 20)
	UIKit.place(back, Rect2(40, 656, 200, 46))
	back.name = "Back"
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	speech.text = ["¡Hombre! Siéntate. ¿Unas cartitas? Yo invito... bueno, invitas tú.", "Hip. Hoy estoy que me salgo. Que se me sale el dinero, digo.", "¿Tú eres uno o dos? Da igual, reparte."][_lv() - 1]
	speech.text += "  (Nv%d · mesa de %d €%s)" % [_lv(), _max_stake(), " · con seguro" if _lv() >= 2 else ""]
	_set_playing(false)

func _change_stake(d: int) -> void:
	stake = clampi(stake + d, 5, clampi(Night.money, 5, _max_stake()))
	stake_label.text = "%d €" % stake

func _set_playing(on: bool) -> void:
	playing = on
	stake_row.visible = not on
	play_row.visible = on
	get_node("Back").disabled = on
	stake = clampi(stake, 5, clampi(Night.money, 5, _max_stake()))
	stake_label.text = "%d €" % stake
	deal_btn.disabled = Night.money < 5 or Night.minutes_left() < MINUTES_COST or Night.over
	_update_labels()
	queue_redraw()

var _coin_used := false

func _lv() -> int:
	return Night.level("chencho")

func _max_stake() -> int:
	return Catalog.CHENCHO_MAX[_lv() - 1]

var played: Array = []        # cartas que ya han salido en esta mano
var _insured := false

func _hint_text() -> String:
	if not Night.has_trinket("chuleta") or current.is_empty():
		return ""
	var cur := _rank(int(current["value"]))
	var hi := 0
	var lo := 0
	for c in deck:
		var r := _rank(int(c["value"]))
		if r > cur:
			hi += 1
		elif r < cur:
			lo += 1
	return "   · Chuleta: quedan %d mayores y %d menores" % [hi, lo]

func _new_deck() -> void:
	deck.clear()
	played.clear()
	for s in SUITS:
		for v in VALUES:
			deck.append({"suit": s, "value": v})
	for i in range(deck.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t = deck[i]
		deck[i] = deck[j]
		deck[j] = t

func _deal() -> void:
	if not Night.spend(stake):
		return
	Night.set_pause("minigame", true)
	Night.advance(MINUTES_COST)
	# En Nv3 el Chencho no vuelve a barajar entre manos: recordar las cartas
	# que han salido da una ventaja real. Se baraja solo si no quedan cartas
	# suficientes para completar otra mano de seis aciertos.
	if _lv() < 3 or deck.size() < MAX_STEPS + 1:
		_new_deck()
	previous = {}
	current = deck.pop_back()
	pot = stake
	steps = 0
	peek = false
	_coin_used = false
	_insured = false
	if _lv() >= 3:
		played.append(current)
	else:
		played = [current]
	speech.text = ["Venga, ese %s... ¿qué te dice el corazón?", "Un %s. Yo diría... no sé lo que diría. Hip.", "Mira, un %s. Como mi número de la suerte. O no."][rng.randi_range(0, 2)] % _card_name(current)
	_set_playing(true)

func _rank(v: int) -> int:
	return VALUES.find(v)

func _prob(dir: int) -> float:
	var cur := _rank(int(current["value"]))
	var win := 0
	var lose := 0
	for c in deck:
		var r := _rank(int(c["value"]))
		if r == cur:
			continue
		if (r > cur) == (dir > 0):
			win += 1
		else:
			lose += 1
	if win + lose == 0:
		return 0.5
	return float(win) / float(win + lose)

## Probabilidad "de baraja entera": la que usa el Chencho cuando va como una cuba.
func _fresh_prob(dir: int) -> float:
	var cur := _rank(int(current["value"]))
	var above := VALUES.size() - 1 - cur
	var below := cur
	if above + below == 0:
		return 0.5
	return float(above if dir > 0 else below) / float(above + below)

func _mult(dir: int) -> float:
	if _prob(dir) <= 0.0:
		return 0.0
	var p := _fresh_prob(dir) if _lv() >= 3 else _prob(dir)
	if p <= 0.0:
		return 0.0
	return snappedf(clampf(0.95 / p, 1.05, 12.0), 0.05)

func _update_labels() -> void:
	if not playing:
		pot_label.text = "Apuesta inicial"
		odds_label.text = "Cada partida dura %d minutos de reloj." % MINUTES_COST
		return
	pot_label.text = "BOTE: %d €" % pot
	var mh := _mult(1)
	var ml := _mult(-1)
	higher_btn.text = "MAYOR  x%.2f" % mh if mh > 0 else "MAYOR"
	lower_btn.text = "MENOR  x%.2f" % ml if ml > 0 else "MENOR"
	higher_btn.disabled = mh <= 0
	lower_btn.disabled = ml <= 0
	cash_btn.text = "PLANTARSE · %d €" % pot
	cash_btn.disabled = steps == 0
	hunch_btn.disabled = peek or Night.luck <= 0
	var shoe := " · Baraja: %d cartas" % deck.size() if _lv() >= 3 else ""
	odds_label.text = "Acierto %d de %d%s%s" % [steps, MAX_STEPS, shoe, _hint_text()]

func _guess(dir: int) -> void:
	if not playing or deck.is_empty():
		return
	var mult := _mult(dir)
	previous = current
	current = deck.pop_back()
	peek = false
	played.append(current)
	var a := _rank(int(previous["value"]))
	var b := _rank(int(current["value"]))
	var wrong := a != b and (b > a) != (dir > 0)
	if wrong and Night.has_trinket("moneda") and not Night.moneda_used:
		Night.moneda_used = true
		speech.text = "Sale un %s... pero tu moneda de dos caras dice que eso no cuenta." % _card_name(current)
	elif a == b:
		speech.text = "¡Otro %s! Igualitas. Eso no cuenta, sigue." % _card_name(current)
	elif (b > a) == (dir > 0):
		steps += 1
		pot = int(round(pot * mult))
		speech.text = ["¡Toma! ¿Cómo lo haces? ¿Haces trampas? Seguro que haces trampas.", "¡Bien! Yo también lo veía. Clarísimo. Hip.", "Esto se pone interesante... ¿sigues o te plantas?"][rng.randi_range(0, 2)]
		if steps >= MAX_STEPS:
			speech.text = "¡Seis seguidas! Me has dejado seco. Toma, toma tu dinero."
			_cash()
			return
	else:
		Night.register_loss("cards")
		if _lv() >= 2 and not _insured and steps > 0:
			_insured = true
			var saved := pot / 2
			Night.earn(saved)
			Night.log_moment("Mayor o menor: el seguro salva %d €" % saved, saved - stake)
			speech.text = "Ha salido un %s. Bueno, bueno, el seguro te devuelve %d €. Hip." % [_card_name(current), saved]
			pot = saved
		else:
			Night.log_moment("Mayor o menor: el Chencho se lleva el bote", -stake)
			speech.text = "%s ¡Ja! Ha salido un %s. Esto me lo bebo a tu salud." % [["Ayyy...", "Uy, uy, uy.", "Ohhh."][rng.randi_range(0, 2)], _card_name(current)]
			pot = 0
		_end_round()
		return
	_update_labels()
	queue_redraw()

func _cash() -> void:
	if not playing:
		return
	pot = Night.register_win("cards", stake, pot)
	Night.log_moment("Mayor o menor: te plantas con %d €" % pot, pot - stake)
	if steps < MAX_STEPS:
		speech.text = "Te plantas con %d €. Cobarde. Pero listo, ¿eh? Listo." % pot
	_end_round()

func _end_round() -> void:
	peek = false
	Night.set_pause("minigame", false)
	_set_playing(false)
	pot_label.text = "Te llevas %d €" % pot if pot > 0 else "Bote perdido"
	Night.check_broke()

func _hunch() -> void:
	if not playing or peek or deck.is_empty() or not Night.spend_luck():
		return
	peek = true
	speech.text = "Mientras el Chencho bebe, ves de reojo la siguiente carta..."
	_update_labels()
	queue_redraw()

func _exit_tree() -> void:
	Night.set_pause("minigame", false)

func _short(c: Dictionary) -> String:
	var v: int = c["value"]
	var n := str(v)
	match v:
		1: n = "A"
		10: n = "S"
		11: n = "C"
		12: n = "R"
	return n

func _card_name(c: Dictionary) -> String:
	var v: int = c["value"]
	var n := str(v)
	match v:
		1: n = "as"
		10: n = "sota"
		11: n = "caballo"
		12: n = "rey"
	return "%s de %s" % [n, c["suit"]]

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), Color("#3b2416"))
	draw_rect(Rect2(Vector2(22, 22), size - Vector2(44, 44)), Color("#1f4d2b"))
	for i in 30:
		draw_rect(Rect2(22 + (i * 97) % 1236, 22 + (i * 53) % 676, 3, 3), Color("#24572f"))
	# mazo
	for i in 4:
		_draw_back(Vector2(420 + i * 2, 188 - i * 2), 0.72)
	if not current.is_empty():
		_draw_card(Vector2(680, 174), current, 0.82)
	if not previous.is_empty():
		_draw_card(Vector2(880, 188), previous, 0.68, 0.58)
	_draw_played_cards()
	if peek and not deck.is_empty():
		_draw_card(Vector2(1060, 210), deck[deck.size() - 1], 0.55, 0.85)
		draw_string(UIKit.FONT_UI, Vector2(1060, 204), "LA SIGUIENTE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, UIKit.GOLD)

func _draw_played_cards() -> void:
	draw_string(UIKit.FONT_SCREEN, Vector2(380, 398), "HAN SALIDO · AGRUPADAS POR VALOR", HORIZONTAL_ALIGNMENT_LEFT, 820, 17, Color("#d8e8d0"))
	var groups := {}
	for value in VALUES:
		groups[value] = []
	for card in played:
		groups[int(card["value"])].append(card)
	for i in VALUES.size():
		var value: int = VALUES[i]
		var x := 380.0 + i * 80.0
		var cards: Array = groups[value]
		if cards.is_empty():
			draw_rect(Rect2(x, 412, 51, 75), Color(0.75, 0.82, 0.72, 0.18), false, 1.0)
			draw_string(UIKit.FONT_UI, Vector2(x + 15, 455), _short({"value": value}), HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.75, 0.82, 0.72, 0.42))
			continue
		for j in cards.size():
			_draw_card(Vector2(x + j * 5, 412 + j * 4), cards[j], 0.3)

func _draw_back(p: Vector2, scale: float = 1.0) -> void:
	var card_size := Vector2(150, 230) * scale
	var r := Rect2(p, card_size)
	draw_rect(r, Color("#7a1f1a"))
	draw_rect(r.grow(-8 * scale), Color("#a8322a"))
	for k in 6:
		draw_rect(Rect2(p + Vector2(20 + k * 19, 30) * scale, Vector2(8, 170) * scale), Color("#7a1f1a"))
	draw_rect(r, Color("#efe2c4"), false, 3.0 * scale)

func _draw_card(p: Vector2, c: Dictionary, s: float, alpha: float = 1.0) -> void:
	var size_v := Vector2(170, 250) * s
	var r := Rect2(p, size_v)
	draw_rect(Rect2(p + Vector2(5, 6), size_v), Color(0, 0, 0, 0.35 * alpha))
	draw_rect(r, Color(0.96, 0.93, 0.85, alpha))
	draw_rect(r, Color(0.3, 0.2, 0.1, alpha), false, 3.0)
	var col := Color("#c9971c")
	match c["suit"]:
		"copas": col = Color("#b8322a")
		"espadas": col = Color("#2b5cad")
		"bastos": col = Color("#2f7a33")
	col.a = alpha
	var v: int = c["value"]
	var label := _short(c)
	draw_string(UIKit.FONT_UI, p + Vector2(10, 34) * s, label, HORIZONTAL_ALIGNMENT_LEFT, -1, int(34 * s), col)
	draw_string(UIKit.FONT_UI, p + Vector2(size_v.x - 44 * s, size_v.y - 12 * s), label, HORIZONTAL_ALIGNMENT_LEFT, -1, int(34 * s), col)
	var cx := p + size_v * 0.5
	var u := 26.0 * s
	match c["suit"]:
		"oros":
			draw_circle(cx, u * 1.4, col)
			draw_circle(cx, u * 0.95, Color(0.96, 0.85, 0.4, alpha))
			draw_circle(cx, u * 0.4, col)
		"copas":
			draw_colored_polygon(PackedVector2Array([cx + Vector2(-u * 1.2, -u * 1.2), cx + Vector2(u * 1.2, -u * 1.2), cx + Vector2(u * 0.5, u * 0.2), cx + Vector2(-u * 0.5, u * 0.2)]), col)
			draw_rect(Rect2(cx + Vector2(-u * 0.15, u * 0.2), Vector2(u * 0.3, u * 0.8)), col)
			draw_rect(Rect2(cx + Vector2(-u * 0.7, u * 1.0), Vector2(u * 1.4, u * 0.3)), col)
		"espadas":
			draw_rect(Rect2(cx + Vector2(-u * 0.15, -u * 1.6), Vector2(u * 0.3, u * 2.4)), col)
			draw_rect(Rect2(cx + Vector2(-u * 0.8, u * 0.7), Vector2(u * 1.6, u * 0.25)), col)
			draw_rect(Rect2(cx + Vector2(-u * 0.2, u * 0.95), Vector2(u * 0.4, u * 0.7)), col.darkened(0.3))
		_:
			draw_line(cx + Vector2(-u * 0.6, u * 1.5), cx + Vector2(u * 0.6, -u * 1.5), col, u * 0.55)
			draw_circle(cx + Vector2(u * 0.6, -u * 1.5), u * 0.4, col)
			draw_circle(cx + Vector2(0, 0), u * 0.3, col.darkened(0.3))
