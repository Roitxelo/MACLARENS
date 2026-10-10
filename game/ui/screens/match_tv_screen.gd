extends Control

## TV 1 a pantalla completa: el partido en directo, la crónica de eventos
## y tus tickets sobre ese partido con su valor de cobro en tiempo real.

const PitchTV := preload("res://ui/widgets/pitch_tv.gd")
const Penalty := preload("res://ui/minigames/penalty_overlay.gd")

var main: Control
var args: Dictionary
var pitch: Control
var feed: Label
var odds_label: Label
var tickets_box: VBoxContainer
var pen_btn: Button
var hunch_btn: Button
var _sig := ""

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#120c08")
	bg.size = size
	add_child(bg)
	# Marco de televisor
	UIKit.panel(self, Rect2(30, 110, 820, 500), Color("#1b1b1d"), Color("#3a3a40"), 8)
	pitch = PitchTV.new()
	UIKit.place(pitch, Rect2(46, 126, 788, 468))
	pitch.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(pitch)
	var side := UIKit.panel(self, Rect2(870, 110, 380, 500), UIKit.SCREEN_BG, UIKit.SCREEN_LINE, 3)
	side.name = "side"
	odds_label = UIKit.label("", 24, UIKit.GOLD, true)
	UIKit.place(odds_label, Rect2(886, 120, 350, 80))
	add_child(odds_label)
	feed = UIKit.label("", 21, UIKit.SCREEN_TEXT, true)
	UIKit.place(feed, Rect2(886, 205, 350, 210))
	feed.clip_text = true
	add_child(feed)
	tickets_box = VBoxContainer.new()
	UIKit.place(tickets_box, Rect2(882, 420, 356, 180))
	tickets_box.add_theme_constant_override("separation", 4)
	add_child(tickets_box)
	var back := UIKit.button("VOLVER AL BAR", "wood", 20)
	UIKit.place(back, Rect2(24, 650, 200, 48))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	var go_machine := UIKit.button("APOSTAR EN LA MÁQUINA", "red", 20)
	UIKit.place(go_machine, Rect2(240, 650, 300, 48))
	go_machine.pressed.connect(func(): main.go("machine", {"tab": "football"}))
	add_child(go_machine)
	pen_btn = UIKit.button("¡PENALTI DEL BÚHO!", "green", 20)
	UIKit.place(pen_btn, Rect2(560, 650, 260, 48))
	pen_btn.tooltip_text = "Búho Nv3: una vez por partido, con ticket a un equipo, lo tiras tú"
	pen_btn.pressed.connect(_open_penalty)
	add_child(pen_btn)
	refresh()

func _open_penalty() -> void:
	var mid: String = PitchTV.pick_match()["id"]
	if not Night.can_penalty(mid):
		return
	Night.set_pause("minigame", true)
	var ov := Penalty.new()
	ov.match_id = mid
	ov.finished.connect(func(scored: bool):
		Night.set_pause("minigame", false)
		Night.penalty_result(mid, scored)
		refresh())
	add_child(ov)

func _exit_tree() -> void:
	Night.set_pause("minigame", false)

func refresh() -> void:
	if feed == null:
		return
	var m := PitchTV.pick_match()
	pen_btn.visible = Night.level("buho") >= 3
	pen_btn.disabled = not Night.can_penalty(m["id"])
	odds_label.text = "CUOTAS  1 %.2f  X %.2f  2 %.2f\n%s" % [m["odds"]["1"], m["odds"]["X"], m["odds"]["2"], "Apuestas abiertas" if Night.football.can_bet(m) else "Apuestas cerradas"]
	var evs: Array = m["events"]
	var lines: Array = []
	for i in range(evs.size() - 1, maxi(-1, evs.size() - 9), -1):
		lines.append("%2d'  %s" % [int(evs[i]["minute"]), evs[i]["text"]])
	if lines.is_empty():
		lines.append("El partido empieza a las %s." % Night.clock_text(m["kickoff"]))
		lines.append("")
		var lv := Night.level("buho")
		lines.append("El Búho (Nv%d):" % lv)
		lines.append(Catalog.CHARACTERS["buho"]["levels"][lv - 1])
		feed.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feed.text = "\n".join(lines)
	var mine: Array = Night.bets.filter(func(b): return b["type"] == "football" and b["match_id"] == m["id"])
	var sig := str(mine.map(func(b): return b["status"]))
	if sig != _sig:
		_sig = sig
		for c in tickets_box.get_children():
			c.queue_free()
		for b in mine:
			var row := UIKit.button("", "green" if b["status"] == "open" else "teal", 19, true)
			row.custom_minimum_size = Vector2(350, 36)
			row.tooltip_text = "Vende la apuesta al valor que marque la cuota en directo"
			row.set_meta("bet", b)
			row.pressed.connect(func():
				if b["status"] == "open":
					Night.cashout(b))
			tickets_box.add_child(row)
	for row in tickets_box.get_children():
		var b: Dictionary = row.get_meta("bet")
		if b["status"] == "open":
			var v := Night.cashout_value(b)
			var profit := v - int(b["stake"])
			row.text = "%s %d € @ %.2f · VENDER %d € (%+d)" % [Night.football.pick_label(m, b["pick"]), b["stake"], b["odds"], v, profit]
			row.disabled = v <= 0
		else:
			row.text = "%s · %s" % [b["label"], {"won": "GANADO", "lost": "PERDIDO", "cashed": "COBRADO"}.get(b["status"], "")]
			row.disabled = true
