extends Control

## El bar: centro de operaciones. Cada cosa apostable está en el escenario.

const BAR := preload("res://assets/concept/mclarens_bar_zone_lucia_v3.png")
const PitchTV := preload("res://ui/widgets/pitch_tv.gd")

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
	UIKit.hotspot(self, Rect2(290, 48, 214, 122), "Tele · Ver el fútbol").pressed.connect(func(): main.go("match_tv"))
	UIKit.hotspot(self, Rect2(965, 200, 270, 230), "Máquina de apuestas").pressed.connect(func(): main.go("machine"))
	UIKit.hotspot(self, Rect2(525, 505, 410, 175), "Diario Gol Local · cartelera").pressed.connect(func(): main.go("paper"))
	UIKit.hotspot(self, Rect2(150, 530, 250, 150), "Tu libreta · gente, objetos y racha").pressed.connect(func(): main.go("notebook"))
	UIKit.hotspot(self, Rect2(580, 178, 145, 188), "Lucía · Rondas y objetos").pressed.connect(func(): main.go("shop"))
	var lucia_tag := UIKit.label("LUCÍA · RONDAS Y OBJETOS", 16, UIKit.GOLD, true)
	lucia_tag.add_theme_stylebox_override("normal", UIKit.box(Color(0.08, 0.04, 0.02, 0.9), Color("#8a5a1c"), 2, 3, 8))
	UIKit.place(lucia_tag, Rect2(540, 368, 225, 30))
	lucia_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(lucia_tag)

	var salon_btn := UIKit.button("SALÓN DE JUEGOS  →", "wood", 19)
	UIKit.place(salon_btn, Rect2(20, 184, 220, 52))
	salon_btn.tooltip_text = "Caballos, billar y cartas"
	salon_btn.pressed.connect(func(): main.go("salon"))
	add_child(salon_btn)

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
		return "BARRA · Fútbol, apuestas y Lucía. El salón reúne caballos, billar y cartas."
	if not nxt.is_empty() and int(nxt["start"]) - now <= 10:
		return "La carrera %d sale a las %s. La máquina acepta apuestas hasta la salida." % [int(nxt["index"]) + 1, Night.clock_text(nxt["start"])]
	return "Tino llega a las 02:00. Quedan %d minutos de noche." % Night.minutes_left()
