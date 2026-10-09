extends Control

## El bar: centro de operaciones. Cada cosa apostable está en el escenario.

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")
const PitchTV := preload("res://ui/widgets/pitch_tv.gd")
const RaceTrack := preload("res://ui/widgets/race_track.gd")

var main: Control
var args: Dictionary
var ticket_label: Label
var tip_label: Label

func _ready() -> void:
	add_child(UIKit.texture_rect(BAR))
	var tv1 := PitchTV.new()
	tv1.compact = true
	UIKit.place(tv1, Rect2(296, 55, 202, 108))
	tv1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tv1)
	var tv2 := RaceTrack.new()
	tv2.compact = true
	UIKit.place(tv2, Rect2(747, 55, 201, 108))
	tv2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tv2)

	UIKit.hotspot(self, Rect2(290, 48, 214, 122), "TV 1 · Ver el fútbol").pressed.connect(func(): main.go("match_tv"))
	UIKit.hotspot(self, Rect2(741, 48, 213, 122), "TV 2 · Canal hípico").pressed.connect(func(): main.go("race_tv"))
	UIKit.hotspot(self, Rect2(965, 200, 270, 230), "Máquina de apuestas").pressed.connect(func(): main.go("machine"))
	UIKit.hotspot(self, Rect2(525, 505, 410, 175), "Diario Gol Local · cartelera").pressed.connect(func(): main.go("paper"))
	UIKit.hotspot(self, Rect2(150, 530, 250, 150), "Tu libreta · gente, objetos y racha").pressed.connect(func(): main.go("contacts"))
	UIKit.hotspot(self, Rect2(40, 222, 190, 260), "El Chencho · Mayor o menor (Nv%d)" % Night.level("chencho")).pressed.connect(func(): main.go("cards"))
	UIKit.hotspot(self, Rect2(250, 185, 700, 240), "Futbolín del fondo · Tino (Nv%d)" % Night.level("tino")).pressed.connect(func(): main.go("rivals"))
	UIKit.hotspot(self, Rect2(510, 62, 225, 110), "Barra de Lucía · rondas y objetos").pressed.connect(func(): main.go("lucia"))

	ticket_label = UIKit.label("", 16, UIKit.SCREEN_TEXT, true)
	ticket_label.add_theme_stylebox_override("normal", UIKit.box(Color(0.03, 0.08, 0.08, 0.88), UIKit.SCREEN_LINE, 2, 3, 8))
	ticket_label.position = Vector2(958, 110)
	add_child(ticket_label)

	tip_label = UIKit.shadow(UIKit.label("", 18, UIKit.CREAM))
	UIKit.place(tip_label, Rect2(240, 684, 800, 30))
	tip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(tip_label)
	if not Night.running and not Night.over:
		Night.start()
	refresh()

func refresh() -> void:
	if ticket_label == null:
		return
	var open := Night.open_bets()
	if open.is_empty():
		ticket_label.visible = false
	else:
		ticket_label.visible = true
		var lines := ["TICKETS ABIERTOS"]
		for b in open.slice(0, 5):
			lines.append("%s · %d € @ %.2f" % [b["label"], b["stake"], b["odds"]])
		if open.size() > 5:
			lines.append("... y %d más" % (open.size() - 5))
		ticket_label.text = "\n".join(lines)
		ticket_label.reset_size()
	tip_label.text = _tip()

func _tip() -> String:
	var now := Night.minute()
	var nxt := Night.races.next_open(now)
	if Night.bets.is_empty() and Night.trinkets.is_empty():
		return "Pasa el ratón por el bar. Cada juego tiene su personaje; Lucía vende rondas y objetos."
	if not nxt.is_empty() and int(nxt["start"]) - now <= 10:
		return "La carrera %d sale a las %s. La máquina acepta apuestas hasta la salida." % [int(nxt["index"]) + 1, Night.clock_text(nxt["start"])]
	return "Tino llega a las 02:00. Quedan %d minutos de noche." % Night.minutes_left()
