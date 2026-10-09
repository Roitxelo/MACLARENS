extends Control

## TV 2 a pantalla completa: canal hípico con la carrera en directo.
## Con El Cortado Nv2+ y un ticket en la carrera, puedes ARREAR a tu caballo:
## una aguja va y viene; pulsa ESPACIO o el botón cuando pase por lo verde.

const RaceTrack := preload("res://ui/widgets/race_track.gd")

var main: Control
var args: Dictionary
var info: Label
var whip_box: Control
var whip_btn: Button
var whip_info: Label
var luck_btn: Button
var needle := 0.0
var _t := 0.0
var last_msg := ""

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#120c08")
	bg.size = size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	UIKit.panel(self, Rect2(30, 110, 1220, 470), Color("#1b1b1d"), Color("#3a3a40"), 8)
	var track := RaceTrack.new()
	UIKit.place(track, Rect2(46, 126, 1188, 438))
	track.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(track)
	info = UIKit.shadow(UIKit.label("", 19, UIKit.CREAM))
	UIKit.place(info, Rect2(560, 656, 700, 40))
	info.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(info)
	var back := UIKit.button("VOLVER AL BAR", "wood", 20)
	UIKit.place(back, Rect2(24, 650, 200, 48))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	var go_machine := UIKit.button("APOSTAR EN LA MÁQUINA", "red", 20)
	UIKit.place(go_machine, Rect2(240, 650, 300, 48))
	go_machine.pressed.connect(func(): main.go("machine", {"tab": "horses"}))
	add_child(go_machine)
	# Arreo
	whip_box = Control.new()
	whip_box.size = size
	whip_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	whip_box.draw.connect(_draw_whip)
	add_child(whip_box)
	whip_btn = UIKit.button("¡ARREAR! (ESPACIO)", "green", 20)
	UIKit.place(whip_btn, Rect2(830, 590, 210, 50))
	whip_btn.pressed.connect(_whip)
	add_child(whip_btn)
	luck_btn = UIKit.button("CORAZONADA", "gold", 16)
	UIKit.place(luck_btn, Rect2(1050, 590, 180, 50))
	luck_btn.tooltip_text = "Gasta 1 de suerte: tu próximo arreo sale perfecto"
	luck_btn.pressed.connect(func():
		Night.hunch_whip()
		refresh())
	add_child(luck_btn)
	whip_info = UIKit.shadow(UIKit.label("", 18, UIKit.GOLD))
	UIKit.place(whip_info, Rect2(390, 572, 420, 26))
	whip_info.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(whip_info)
	refresh()

func _process(delta: float) -> void:
	_t += delta
	# triángulo 0..1..0 en ~1,1 s
	var ph := fmod(_t / 1.1, 2.0)
	needle = ph if ph < 1.0 else 2.0 - ph
	whip_box.queue_redraw()

func _whip_race() -> Dictionary:
	var r := RaceTrack.pick_race()
	if r.is_empty() or r["state"] != "running":
		return {}
	if Night.my_horse(int(r["index"])) < 0 or Night.whips_left(int(r["index"])) <= 0:
		return {}
	return r

func _unhandled_key_input(event: InputEvent) -> void:
	if event.pressed and not event.echo and (event as InputEventKey).keycode == KEY_SPACE:
		_whip()

func _whip() -> void:
	var r := _whip_race()
	if r.is_empty():
		return
	var quality := 1.0 - absf(needle - 0.5) * 2.0   # 1 en el centro
	var txt := Night.whip(int(r["index"]), quality)
	if txt != "":
		last_msg = txt
	refresh()

func _draw_whip() -> void:
	var r := _whip_race()
	if r.is_empty():
		return
	var bar := Rect2(390, 604, 420, 30)
	whip_box.draw_rect(bar.grow(3), Color.BLACK)
	whip_box.draw_rect(bar, Color("#5a3822"))
	var gh := Night.whip_green_half()
	var green := Rect2(bar.position.x + bar.size.x * (0.5 - gh * 0.5), bar.position.y, bar.size.x * gh, bar.size.y)
	whip_box.draw_rect(green, Color("#3f9a4a"))
	var perfect := Rect2(bar.position.x + bar.size.x * (0.5 - gh * 0.175), bar.position.y, bar.size.x * gh * 0.35, bar.size.y)
	whip_box.draw_rect(perfect, Color("#9ff59a"))
	var nx := bar.position.x + bar.size.x * needle
	whip_box.draw_rect(Rect2(nx - 3, bar.position.y - 8, 6, bar.size.y + 16), UIKit.GOLD)

func refresh() -> void:
	if info == null:
		return
	var race := RaceTrack.pick_race()
	var mine: Array = Night.bets.filter(func(b): return b["type"] == "horse" and int(b["race"]) == int(race["index"]))
	if mine.is_empty():
		info.text = "No llevas nada en esta carrera." if race["state"] != "open" else "Las apuestas cierran a la salida (%s)." % Night.clock_text(race["start"])
	else:
		var parts: Array = []
		for b in mine:
			parts.append("%s %d €" % [race["horses"][b["horse"]]["name"], b["stake"]])
		info.text = "Tus caballos: " + ", ".join(parts)
	var wr := _whip_race()
	whip_btn.visible = not wr.is_empty()
	luck_btn.visible = not wr.is_empty()
	luck_btn.disabled = Night.luck <= 0 or Night.perfect_whip
	if not wr.is_empty():
		whip_info.text = "%sArreos: %d%s" % [last_msg + " · " if last_msg != "" else "", Night.whips_left(int(wr["index"])), "  · el próximo, perfecto" if Night.perfect_whip else ""]
	elif Night.level("cortado") < 2 and not mine.is_empty() and race["state"] == "running":
		whip_info.text = "Invita al Cortado (Nv2) para poder arrear."
	elif race["state"] != "running":
		whip_info.text = last_msg
