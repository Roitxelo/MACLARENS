extends Control

## Máquina McLarens: apuestas de fútbol (1X2 con cobro anticipado),
## caballos (ganador) y lista de tickets. El arte de la máquina hace de
## marco; la pantalla interior se redibuja con datos reales.

const MACHINE := preload("res://assets/concept/betting_machine_interface_v1.png")
const SCREEN := Rect2(250, 135, 750, 475)

var main: Control
var args: Dictionary
var tab := "football"
var stake := 10
var sel_match := ""
var sel_pick := ""
var sel_race := -1
var sel_horse := -1
var horse_kind := "win"
var perk_label: Label
var content: Control
var tab_buttons := {}
var status_label: Label
var stake_label: Label
var bet_button: Button
var hunch_label: Label
var _signature := ""
var _odds_buttons: Array = []    # [{button, match_id, pick}]
var _cash_buttons: Array = []    # [{button, bet}]
var _match_labels: Array = []    # [{label, match_id}]

func _ready() -> void:
	add_child(UIKit.texture_rect(MACHINE))
	UIKit.panel(self, SCREEN, UIKit.SCREEN_BG, UIKit.SCREEN_LINE, 3)
	var x := SCREEN.position.x + 12
	for t in [["football", "FÚTBOL"], ["horses", "CABALLOS"], ["tickets", "MIS BOLETOS"]]:
		var b := UIKit.button(t[1], "teal", 24, true)
		UIKit.place(b, Rect2(x, SCREEN.position.y + 10, 170, 38))
		_plastic_button(b, UIKit.SCREEN_PANEL)
		b.pressed.connect(_set_tab.bind(t[0]))
		add_child(b)
		tab_buttons[t[0]] = b
		x += 180
	content = Control.new()
	content.position = Vector2.ZERO
	content.size = Vector2(1280, 720)
	content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(content)

	# Barra inferior: selección, importe, apostar, corazonada.
	var by := SCREEN.end.y - 64
	UIKit.panel(self, Rect2(SCREEN.position.x + 8, by - 6, SCREEN.size.x - 16, 62), UIKit.SCREEN_PANEL, UIKit.SCREEN_LINE, 2)
	status_label = UIKit.label("", 21, UIKit.SCREEN_TEXT, true)
	UIKit.place(status_label, Rect2(SCREEN.position.x + 18, by - 2, 270, 54))
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(status_label)
	var stake_caption := UIKit.label("IMPORTE · MÁX. %d €" % Night.MAX_TICKET, 16, UIKit.GOLD, true)
	UIKit.place(stake_caption, Rect2(SCREEN.position.x + 296, by - 24, 210, 22))
	stake_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(stake_caption)
	var minus := UIKit.button("−5", "teal", 24, true)
	UIKit.place(minus, Rect2(SCREEN.position.x + 296, by, 50, 48))
	_plastic_button(minus, Color("#33463e"))
	minus.pressed.connect(func(): _change_stake(-1))
	add_child(minus)
	stake_label = UIKit.label("", 30, UIKit.GOLD, true)
	stake_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stake_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stake_label.add_theme_stylebox_override("normal", UIKit.box(Color("#081c1c"), Color("#d39b3d"), 2, 2, 4))
	UIKit.place(stake_label, Rect2(SCREEN.position.x + 352, by, 96, 48))
	add_child(stake_label)
	var plus := UIKit.button("+5", "teal", 24, true)
	UIKit.place(plus, Rect2(SCREEN.position.x + 454, by, 50, 48))
	_plastic_button(plus, Color("#33463e"))
	plus.pressed.connect(func(): _change_stake(1))
	add_child(plus)
	bet_button = UIKit.button("APOSTAR", "red", 26, true)
	UIKit.place(bet_button, Rect2(SCREEN.position.x + 516, by, 154, 48))
	_plastic_button(bet_button, Color("#9f3429"))
	bet_button.pressed.connect(_place_bet)
	add_child(bet_button)
	hunch_label = UIKit.shadow(UIKit.label("", 18, UIKit.GOLD))
	UIKit.place(hunch_label, Rect2(250, 616, 750, 50))
	hunch_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hunch_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(hunch_label)

	perk_label = UIKit.shadow(UIKit.label("", 17, UIKit.CREAM))
	UIKit.place(perk_label, Rect2(250, 664, 750, 50))
	perk_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	perk_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(perk_label)
	var back := UIKit.button("VOLVER AL BAR", "wood", 20)
	UIKit.place(back, Rect2(24, 650, 200, 48))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	UIKit.hotspot(self, Rect2(1078, 410, 50, 62), "Volver").pressed.connect(func(): main.go("bar"))

	if args.has("tab"):
		tab = str(args["tab"])
	for mm in Night.football.matches:
		if Night.football.can_bet(mm):
			sel_match = mm["id"]
			break
	_set_tab(tab)

func _set_tab(t: String) -> void:
	tab = t
	for k in tab_buttons:
		tab_buttons[k].add_theme_stylebox_override("normal", UIKit.box(UIKit.GOLD if k == tab else UIKit.SCREEN_PANEL, UIKit.SCREEN_LINE, 3, 3, 10))
		tab_buttons[k].add_theme_color_override("font_color", UIKit.INK if k == tab else UIKit.SCREEN_TEXT)
	hunch_label.text = ""
	_signature = ""
	refresh()

func _plastic_button(button: Button, color: Color) -> void:
	button.add_theme_stylebox_override("normal", UIKit.box(color, Color("#aa8b52"), 3, 3, 3))
	button.add_theme_stylebox_override("hover", UIKit.box(color.lightened(0.12), UIKit.GOLD, 3, 3, 3))
	button.add_theme_stylebox_override("pressed", UIKit.box(color.darkened(0.2), Color("#4b351f"), 4, 3, 3))
	button.add_theme_stylebox_override("disabled", UIKit.box(color.darkened(0.45), Color("#4b4638"), 2, 3, 3))

func _change_stake(dir: int) -> void:
	var step := 5 if stake < 50 or (dir < 0 and stake <= 50) else 10
	stake = clampi(stake + dir * step, 5, maxi(5, mini(Night.money, Night.MAX_TICKET)))
	_update_bottom()

func _structure_signature() -> String:
	var parts: Array = [tab, sel_race, sel_match, sel_pick, sel_horse, horse_kind, Night.bets.size(), Night.level("cortado")]
	for m in Night.football.matches:
		parts.append(m["state"])
		parts.append(Night.football.can_bet(m))
	for b in Night.bets:
		parts.append(b["status"])
	for r in Night.races.open_races(Night.minute(), 3):
		parts.append(r["index"])
	return str(parts)

func refresh() -> void:
	if content == null:
		return
	var sig := _structure_signature()
	if sig != _signature:
		_signature = sig
		_rebuild()
	else:
		_update_live()
	_update_bottom()

func _clear() -> void:
	for c in content.get_children():
		c.queue_free()
	_odds_buttons.clear()
	_cash_buttons.clear()
	_match_labels.clear()

func _rebuild() -> void:
	_clear()
	match tab:
		"football": _build_football()
		"horses": _build_horses()
		_: _build_tickets()

# --- Fútbol ------------------------------------------------------------------

func _build_football() -> void:
	var y := SCREEN.position.y + 60
	for m in Night.football.matches:
		var card := UIKit.panel(content, Rect2(SCREEN.position.x + 10, y, SCREEN.size.x - 20, 150), UIKit.SCREEN_PANEL, UIKit.GOLD if m["id"] == sel_match else UIKit.SCREEN_LINE, 2)
		card.name = "card_" + m["id"]
		var head := UIKit.label("", 26, UIKit.GOLD, true)
		UIKit.place(head, Rect2(SCREEN.position.x + 24, y + 6, SCREEN.size.x - 50, 30))
		content.add_child(head)
		var sub := UIKit.label("", 21, UIKit.SCREEN_TEXT, true)
		UIKit.place(sub, Rect2(SCREEN.position.x + 24, y + 36, SCREEN.size.x - 50, 26))
		content.add_child(sub)
		var bar_bg := ColorRect.new()
		bar_bg.color = Color("#2b5cad")
		bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		UIKit.place(bar_bg, Rect2(SCREEN.end.x - 230, y + 42, 200, 12))
		content.add_child(bar_bg)
		var bar_fg := ColorRect.new()
		bar_fg.color = Color("#c94b3b")
		bar_fg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		UIKit.place(bar_fg, Rect2(SCREEN.end.x - 230, y + 42, 100, 12))
		content.add_child(bar_fg)
		var bar_l := UIKit.label("PRESIÓN", 16, UIKit.SCREEN_TEXT, true)
		UIKit.place(bar_l, Rect2(SCREEN.end.x - 300, y + 36, 70, 22))
		content.add_child(bar_l)
		_match_labels.append({"head": head, "sub": sub, "match_id": m["id"], "bar": bar_fg, "bar_bg": bar_bg, "bar_l": bar_l})
		var bx := SCREEN.position.x + 24
		for pick in ["1", "X", "2"]:
			var b := UIKit.button("", "teal", 22, true)
			UIKit.place(b, Rect2(bx, y + 70, 225, 66))
			b.pressed.connect(_select_pick.bind(m["id"], pick))
			if m["id"] == sel_match and pick == sel_pick:
				b.add_theme_stylebox_override("normal", UIKit.box(Color("#5a4512"), UIKit.GOLD, 3, 3, 10))
			b.disabled = not Night.football.can_bet(m)
			content.add_child(b)
			_odds_buttons.append({"button": b, "match_id": m["id"], "pick": pick})
			bx += 235
		y += 162
	_update_live()

func _select_pick(match_id: String, pick: String) -> void:
	sel_match = match_id
	sel_pick = pick
	refresh()

func _odds_delta(m: Dictionary, pick: String) -> String:
	var now: float = m["odds"][pick]
	var before: float = m["prev_odds"].get(pick, now)
	if absf(now - before) < 0.005 or m["state"] != "live":
		return ""
	return "  %+.2f" % (now - before)

func _update_live() -> void:
	for e in _match_labels:
		var m := Night.football.get_match(e["match_id"])
		var sim: MatchSimulator = m["sim"]
		var state := ""
		match m["state"]:
			"pre": state = "EMPIEZA A LAS %s" % Night.clock_text(m["kickoff"])
			"live": state = "EN VIVO %d'  ·  %d-%d" % [int(m["minute"]), sim.home_score, sim.away_score]
			_: state = "FINAL %d-%d" % [sim.home_score, sim.away_score]
		e["head"].text = "%s - %s     %s" % [m["home"], m["away"], state]
		e["sub"].size.x = SCREEN.size.x - 340 if m["state"] == "live" else SCREEN.size.x - 50
		var evs: Array = m["events"]
		var sub := "Apuestas abiertas hasta el minuto %d" % FootballMarket.BET_CLOSE_MINUTE
		if not evs.is_empty() and m["state"] != "pre":
			sub = "Último: %s" % evs[evs.size() - 1]["text"]
		if not Night.football.can_bet(m) and m["state"] != "done":
			sub = "Apuestas cerradas · " + sub
		e["sub"].text = sub
		var live: bool = m["state"] == "live"
		for k in ["bar", "bar_bg", "bar_l"]:
			e[k].visible = live
		if live:
			var pr := sim.pressure()
			e["bar"].size.x = 200.0 * float(pr["home_share"])
			if Night.level("buho") >= 2:
				e["bar_l"].text = "%d%%-%d%%" % [int(pr["home_10"] * 100), int(pr["away_10"] * 100)]
				e["bar_l"].tooltip_text = "Probabilidad de gol de cada equipo en 10 min"
	for o in _odds_buttons:
		var m := Night.football.get_match(o["match_id"])
		var pick: String = o["pick"]
		var name_s: String = "Empate" if pick == "X" else str(m["home"] if pick == "1" else m["away"])
		o["button"].text = "%s  %s\n%.2f%s" % [pick, name_s, m["odds"][pick], _odds_delta(m, pick)]
	for c in _cash_buttons:
		var v := Night.cashout_value(c["bet"])
		var profit := v - int(c["bet"]["stake"])
		c["button"].text = "VENDER %d €  (%+d)" % [v, profit]
		c["button"].tooltip_text = "Valor en directo según la cuota actual; entre paréntesis, beneficio o pérdida"
		c["button"].disabled = v <= 0

# --- Caballos ----------------------------------------------------------------

func _build_horses() -> void:
	var races := Night.races.open_races(Night.minute(), 3)
	if races.is_empty():
		var l := UIKit.label("No quedan carreras esta noche.", 28, UIKit.SCREEN_TEXT, true)
		UIKit.place(l, Rect2(SCREEN.position.x + 30, SCREEN.position.y + 120, 600, 40))
		content.add_child(l)
		return
	var valid := false
	for r in races:
		if int(r["index"]) == sel_race:
			valid = true
	if not valid:
		sel_race = int(races[0]["index"])
		sel_horse = -1
	var x := SCREEN.position.x + 12
	for r in races:
		var b := UIKit.button("C%d · %s" % [int(r["index"]) + 1, Night.clock_text(r["start"])], "teal", 22, true)
		UIKit.place(b, Rect2(x, SCREEN.position.y + 56, 160, 34))
		if int(r["index"]) == sel_race:
			b.add_theme_stylebox_override("normal", UIKit.box(Color("#5a4512"), UIKit.GOLD, 3, 3, 10))
		b.pressed.connect(func():
			sel_race = int(r["index"])
			sel_horse = -1
			hunch_label.text = ""
			refresh())
		content.add_child(b)
		x += 168
	if Night.level("cortado") >= 3:
		for k in [["win", "GANADOR"], ["place", "COLOCADO"]]:
			var kb := UIKit.button(k[1], "teal", 20, true)
			UIKit.place(kb, Rect2(x + 10 + (0 if k[0] == "win" else 112), SCREEN.position.y + 56, 106, 34))
			if horse_kind == k[0]:
				kb.add_theme_stylebox_override("normal", UIKit.box(Color("#5a4512"), UIKit.GOLD, 3, 3, 10))
			kb.pressed.connect(func():
				horse_kind = k[0]
				refresh())
			content.add_child(kb)
	else:
		horse_kind = "win"
	var race: Dictionary = Night.races.races[sel_race]
	var y := SCREEN.position.y + 98
	for hidx in 6:
		var horse: Dictionary = race["horses"][hidx]
		var b := UIKit.button("", "teal", 22, true)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.text = "%d   %s" % [hidx + 1, horse["name"]]
		UIKit.place(b, Rect2(SCREEN.position.x + 12, y, SCREEN.size.x - 24, 38))
		if hidx == sel_horse:
			b.add_theme_stylebox_override("normal", UIKit.box(Color("#5a4512"), UIKit.GOLD, 3, 3, 10))
		if Night.has_trinket("gafas") and int(race["tip_horse"]) == hidx:
			b.text += "     << EN FORMA (gafas)"
		b.pressed.connect(func():
			sel_horse = hidx
			refresh())
		content.add_child(b)
		var swatch := ColorRect.new()
		swatch.color = Color(horse["color"])
		swatch.mouse_filter = Control.MOUSE_FILTER_IGNORE
		UIKit.place(swatch, Rect2(SCREEN.position.x + 44, y + 10, 12, 18))
		content.add_child(swatch)
		var shown_odds: float = float(horse["odds"]) if horse_kind == "win" else Night.horse_place_odds(horse)
		var odds := UIKit.label("%.1f" % shown_odds, 28, UIKit.GOLD, true)
		odds.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		UIKit.place(odds, Rect2(SCREEN.end.x - 140, y + 2, 110, 34))
		content.add_child(odds)
		y += 42

# --- Tickets -----------------------------------------------------------------

func _build_tickets() -> void:
	var y := SCREEN.position.y + 60
	if Night.bets.is_empty():
		var l := UIKit.label("Todavía no has apostado nada esta noche.", 26, UIKit.SCREEN_TEXT, true)
		UIKit.place(l, Rect2(SCREEN.position.x + 30, y + 40, 600, 40))
		content.add_child(l)
		return
	var shown: Array = Night.bets.duplicate()
	shown.reverse()
	shown.sort_custom(func(a, b): return a["status"] == "open" and b["status"] != "open")
	for b in shown.slice(0, 8):
		var color := UIKit.SCREEN_TEXT
		var status := "ABIERTO"
		match b["status"]:
			"won":
				color = Color("#9ff59a"); status = "GANADO +%d €" % b["payout"]
			"lost":
				color = Color("#ff9b8a"); status = "PERDIDO"
			"cashed":
				color = UIKit.GOLD; status = "COBRADO %d €" % b["payout"]
			"refunded":
				color = UIKit.CREAM; status = "DEVUELTO"
		var l := UIKit.label("%s  %s · %d € @ %.2f" % [b["placed_at"], b["label"], b["stake"], b["odds"]], 21, color, true)
		UIKit.place(l, Rect2(SCREEN.position.x + 18, y, 480, 32))
		l.clip_text = true
		content.add_child(l)
		if b["status"] == "open" and b["type"] == "football":
			var cb := UIKit.button("VENDER", "green", 20, true)
			UIKit.place(cb, Rect2(SCREEN.end.x - 220, y - 2, 200, 34))
			cb.tooltip_text = "Vende la apuesta al valor que marque la cuota en directo"
			cb.pressed.connect(func():
				Night.cashout(b)
				refresh())
			content.add_child(cb)
			_cash_buttons.append({"button": cb, "bet": b})
		else:
			var s := UIKit.label(status, 21, color, true)
			s.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			UIKit.place(s, Rect2(SCREEN.end.x - 230, y, 210, 32))
			content.add_child(s)
		y += 40
	_update_live()

# --- Barra inferior ------------------------------------------------------------

func _update_bottom() -> void:
	stake = clampi(stake, 5, maxi(5, mini(Night.money, Night.MAX_TICKET)))
	stake_label.text = "%d €" % stake
	var can := false
	var txt := ""
	if tab == "football":
		var m := Night.football.get_match(sel_match)
		if m.is_empty() or sel_pick == "":
			txt = "Elige un resultado: 1, X o 2"
		elif not Night.football.can_bet(m):
			txt = "Ese partido ya no admite apuestas"
		else:
			var o: float = m["odds"][sel_pick]
			txt = "%s @ %.2f → %d €" % [Night.football.pick_label(m, sel_pick), o, int(round(stake * o))]
			can = true

	elif tab == "horses":
		if sel_race < 0 or sel_horse < 0:
			txt = "Elige un caballo"
		else:
			var h: Dictionary = Night.races.races[sel_race]["horses"][sel_horse]
			var ho: float = float(h["odds"]) if horse_kind == "win" else Night.horse_place_odds(h)
			txt = "%s%s @ %.1f → %d €" % [h["name"], " (col.)" if horse_kind == "place" else "", ho, int(round(stake * ho))]
			can = Night.races.races[sel_race]["state"] == "open"

	else:
		txt = "Cobra antes del final si la cosa se tuerce"
	status_label.text = txt
	bet_button.disabled = not can or Night.money < stake
	match tab:
		"football":
			var lv := Night.level("buho")
			perk_label.text = "EL BÚHO Nv%d · %s" % [lv, Catalog.CHARACTERS["buho"]["levels"][lv - 1]]
		"horses":
			var lv := Night.level("cortado")
			perk_label.text = "EL CORTADO Nv%d · %s" % [lv, Catalog.CHARACTERS["cortado"]["levels"][lv - 1]]
		_:
			perk_label.text = Night.streak_text()

func _live_match_id() -> String:
	for m in Night.football.matches:
		if m["state"] == "live":
			return m["id"]
	return ""

func _place_bet() -> void:
	var ok := false
	if tab == "football":
		ok = Night.place_football(sel_match, sel_pick, stake)
	elif tab == "horses":
		ok = Night.place_horse(sel_race, sel_horse, stake, horse_kind)
	if ok:
		sel_pick = ""
		sel_horse = -1
	refresh()

