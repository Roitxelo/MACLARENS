extends Control

## Pista del canal hípico. Se usa en pequeño dentro de la TV del bar y a
## pantalla completa en la vista de carreras.

var compact := false
var race: Dictionary = {}
var _t := 0.0

func _process(delta: float) -> void:
	_t += delta
	race = pick_race()
	queue_redraw()

## Carrera que toca mostrar: la que corre, la recién terminada o la próxima.
static func pick_race() -> Dictionary:
	var running := Night.races.current_running()
	if not running.is_empty():
		return running
	var now := Night.minute()
	for r in Night.races.races:
		if r["state"] == "done" and now - (int(r["start"]) + HorseRaces.RACE_MINUTES) < 12:
			return r
	var nxt := Night.races.next_open(now)
	if not nxt.is_empty():
		return nxt
	return Night.races.races[Night.races.races.size() - 1]

func _bet_horses(r: Dictionary) -> Array:
	var out: Array = []
	for b in Night.bets:
		if b["type"] == "horse" and int(b["race"]) == int(r["index"]):
			out.append(int(b["horse"]))
	return out

func _draw() -> void:
	if race.is_empty():
		return
	var w := size.x
	var h := size.y
	var font: Font = UIKit.FONT_SCREEN
	draw_rect(Rect2(0, 0, w, h), Color("#2f6b2a"))
	# Gradas al fondo
	var top := h * (0.18 if compact else 0.14)
	draw_rect(Rect2(0, 0, w, top), Color("#3a2a3f"))
	var step_x := 6.0 if compact else 12.0
	var x := 0.0
	var i := 0
	while x < w:
		var col: Color = [Color("#c94b3b"), Color("#f0dca9"), Color("#2e86c1"), Color("#f1c40f")][i % 4]
		draw_rect(Rect2(x, top * 0.45 + (i % 3) * 2, step_x * 0.6, step_x * 0.6), col.darkened(0.3))
		x += step_x
		i += 1
	var lane_top := top + 4
	var lane_h := (h - lane_top - (4 if compact else 30)) / 6.0
	var left := 28.0 if compact else 210.0
	var right := w - (14.0 if compact else 60.0)
	for l in 6:
		var y := lane_top + l * lane_h
		draw_rect(Rect2(0, y, w, lane_h), Color("#8b6a3e") if l % 2 == 0 else Color("#9a7748"))
		draw_line(Vector2(0, y), Vector2(w, y), Color("#f4ead0", 0.5), 1.0)
	draw_rect(Rect2(right, lane_top, 4 if compact else 6, lane_h * 6), Color.WHITE)
	var state: String = race["state"]
	if state == "finished":
		state = "running"
	var bets := _bet_horses(race)
	for hidx in 6:
		var horse: Dictionary = race["horses"][hidx]
		var pos := 0.0 if state == "open" else Night.races.horse_position(race, hidx)
		var y := lane_top + hidx * lane_h + lane_h * 0.5
		var hx := left + (right - left - (14 if compact else 40)) * pos
		_draw_horse(Vector2(hx, y), lane_h, Color(horse["color"]), state == "running", hidx)
		if not compact and state == "open" and Night.has_trinket("gafas") and int(race["tip_horse"]) == hidx:
			draw_string(font, Vector2(left + 70, y + 7), "<< EN FORMA (gafas)", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, UIKit.GOLD)
		if bets.has(hidx):
			draw_rect(Rect2(hx - 4, y - lane_h * 0.48, (18 if compact else 48), lane_h * 0.96), UIKit.GOLD, false, 2.0)
		if compact:
			draw_string(font, Vector2(3, y + 5), str(hidx + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color.WHITE)
		else:
			draw_rect(Rect2(6, y - lane_h * 0.42, left - 18, lane_h * 0.84), Color(0, 0, 0, 0.55))
			draw_string(font, Vector2(14, y + 7), "%d %s" % [hidx + 1, horse["name"]], HORIZONTAL_ALIGNMENT_LEFT, left - 70, 22, UIKit.GOLD if bets.has(hidx) else Color.WHITE)
			draw_string(font, Vector2(left - 58, y + 7), "%.1f" % horse["odds"], HORIZONTAL_ALIGNMENT_RIGHT, 44, 22, UIKit.SCREEN_TEXT)
	# Rótulo superior
	var title := ""
	match state:
		"open":
			var mins := int(race["start"]) - Night.minute()
			title = "C%d · SALIDA %s · EN %d MIN" % [int(race["index"]) + 1, Night.clock_text(race["start"]), mins]
		"running":
			title = "C%d · ¡EN CARRERA!" % (int(race["index"]) + 1)
		_:
			var wi := Night.races.winner(race)
			title = "C%d · GANA %d %s" % [int(race["index"]) + 1, wi + 1, race["horses"][wi]["name"]]
	var fs := 15 if compact else 30
	draw_rect(Rect2(0, 0, w, fs + 6), Color(0, 0, 0, 0.6))
	draw_string(font, Vector2(6, fs), title, HORIZONTAL_ALIGNMENT_LEFT, w - 12, fs, UIKit.GOLD)
	if not compact and state == "done":
		var order: Array = race["order"]
		var txt := "LLEGADA: "
		for k in 3:
			txt += "%d.º %s   " % [k + 1, race["horses"][order[k]]["name"]]
		draw_rect(Rect2(0, h - 28, w, 28), Color(0, 0, 0, 0.7))
		draw_string(font, Vector2(10, h - 7), txt, HORIZONTAL_ALIGNMENT_LEFT, w - 20, 22, Color.WHITE)

func _draw_horse(at: Vector2, lane_h: float, silk: Color, moving: bool, seed_i: int) -> void:
	var s := lane_h / 22.0
	if compact:
		s = lane_h / 16.0
	var body := Color("#5b3a1e") if seed_i % 2 == 0 else Color("#3a2414")
	if seed_i == 3:
		body = Color("#d9d2c5")
	var phase := int((_t * 10.0 + seed_i * 1.7)) % 2 if moving else 0
	var o := at + Vector2(0, -2 * s)
	# patas
	var leg := 5.0 * s
	if phase == 0:
		draw_rect(Rect2(o + Vector2(3 * s, 3 * s), Vector2(2 * s, leg)), body.darkened(0.3))
		draw_rect(Rect2(o + Vector2(14 * s, 3 * s), Vector2(2 * s, leg)), body.darkened(0.3))
	else:
		draw_rect(Rect2(o + Vector2(1 * s, 3 * s), Vector2(2 * s, leg * 0.8)), body.darkened(0.3))
		draw_rect(Rect2(o + Vector2(6 * s, 3 * s), Vector2(2 * s, leg)), body.darkened(0.3))
		draw_rect(Rect2(o + Vector2(12 * s, 3 * s), Vector2(2 * s, leg)), body.darkened(0.3))
		draw_rect(Rect2(o + Vector2(17 * s, 3 * s), Vector2(2 * s, leg * 0.8)), body.darkened(0.3))
	# cuerpo, cuello, cabeza, cola
	draw_rect(Rect2(o + Vector2(0, -3 * s), Vector2(18 * s, 7 * s)), body)
	draw_rect(Rect2(o + Vector2(15 * s, -8 * s), Vector2(4 * s, 7 * s)), body)
	draw_rect(Rect2(o + Vector2(17 * s, -9 * s), Vector2(6 * s, 4 * s)), body)
	draw_rect(Rect2(o + Vector2(-4 * s, -2 * s), Vector2(4 * s, 2 * s)), body.darkened(0.4))
	# jinete
	draw_rect(Rect2(o + Vector2(6 * s, -9 * s), Vector2(6 * s, 6 * s)), silk)
	draw_rect(Rect2(o + Vector2(8 * s, -12 * s), Vector2(3 * s, 3 * s)), Color("#f0c8a0"))
