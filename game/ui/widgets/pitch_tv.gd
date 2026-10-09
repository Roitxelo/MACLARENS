extends Control

## Retransmisión de fútbol: campo visto desde arriba con jugadores que se
## mueven hacia donde ocurre la acción. Marcador y minuto encima.

var compact := false
var match_data: Dictionary = {}
var _t := 0.0
var _ball := Vector2(0.5, 0.5)

static func pick_match() -> Dictionary:
	var fm: FootballMarket = Night.football
	for m in fm.matches:
		if m["state"] == "live":
			return m
	var now := Night.minute()
	for m in fm.matches:
		if m["state"] == "done" and now - (int(m["kickoff"]) + 90) < 25:
			return m
	for m in fm.matches:
		if m["state"] == "pre":
			return m
	return fm.matches[fm.matches.size() - 1]

func _process(delta: float) -> void:
	_t += delta
	match_data = pick_match()
	var target := Vector2(0.5, 0.5)
	if match_data["state"] == "live":
		var evs: Array = match_data["events"]
		var last: Dictionary = evs[evs.size() - 1] if not evs.is_empty() else {}
		var t: int = int(last.get("type", 0))
		var home_side := t in [MatchSimulator.EventType.GOAL_HOME, MatchSimulator.EventType.CORNER_HOME, MatchSimulator.EventType.CARD_AWAY, MatchSimulator.EventType.INJURY_AWAY]
		var away_side := t in [MatchSimulator.EventType.GOAL_AWAY, MatchSimulator.EventType.CORNER_AWAY, MatchSimulator.EventType.CARD_HOME, MatchSimulator.EventType.INJURY_HOME]
		target = Vector2(0.5 + 0.28 * sin(_t * 0.7) , 0.5 + 0.3 * sin(_t * 1.3 + 1.0))
		if home_side:
			target.x = 0.8 + 0.08 * sin(_t * 2.0)
		elif away_side:
			target.x = 0.2 + 0.08 * sin(_t * 2.0)
	_ball = _ball.lerp(target, clampf(delta * 1.5, 0.0, 1.0))
	queue_redraw()

func _draw() -> void:
	if match_data.is_empty():
		return
	var w := size.x
	var h := size.y
	var font: Font = UIKit.FONT_SCREEN
	var stripes := 8
	for i in stripes:
		draw_rect(Rect2(w * i / stripes, 0, w / stripes + 1, h), Color("#2f7a33") if i % 2 == 0 else Color("#358a3a"))
	var m := 6.0 if compact else 30.0
	var field := Rect2(m, m + (14 if compact else 40), w - m * 2, h - m * 2 - (14 if compact else 80))
	var line := Color(1, 1, 1, 0.7)
	draw_rect(field, line, false, 2.0)
	draw_line(Vector2(field.get_center().x, field.position.y), Vector2(field.get_center().x, field.end.y), line, 2.0)
	draw_arc(field.get_center(), field.size.y * 0.18, 0, TAU, 24, line, 2.0)
	var box_h := field.size.y * 0.5
	draw_rect(Rect2(field.position.x, field.get_center().y - box_h / 2, field.size.x * 0.12, box_h), line, false, 2.0)
	draw_rect(Rect2(field.end.x - field.size.x * 0.12, field.get_center().y - box_h / 2, field.size.x * 0.12, box_h), line, false, 2.0)
	var live: bool = match_data["state"] == "live"
	var bp := field.position + field.size * _ball
	var r := 3.0 if compact else 7.0
	for side in 2:
		var col := Color("#b8322a") if side == 0 else Color("#2b5cad")
		if int(match_data["index"]) == 1:
			col = Color("#e0e0e0") if side == 0 else Color("#e8b628")
		for k in 6:
			var home_x := 0.12 + 0.13 * (k % 3) + (0.0 if k < 3 else 0.06)
			var base := Vector2(home_x if side == 0 else 1.0 - home_x, 0.2 + 0.6 * float(k) / 5.0)
			if live:
				base = base.lerp(_ball, 0.25) + Vector2(sin(_t * 1.7 + k + side), cos(_t * 1.3 + k * 2.0)) * 0.02
			var pos := field.position + field.size * base
			draw_circle(pos, r, col)
			draw_circle(pos + Vector2(0, -r * 0.4), r * 0.45, Color("#f0c8a0"))
	draw_circle(bp, r * 0.6, Color.WHITE)
	# marcador
	var sim: MatchSimulator = match_data["sim"]
	var status := ""
	match match_data["state"]:
		"pre": status = "%s" % Night.clock_text(match_data["kickoff"])
		"live": status = "%d'" % int(match_data["minute"])
		_: status = "FINAL"
	var home_s := str(match_data["home"])
	var away_s := str(match_data["away"])
	if compact:
		home_s = home_s.substr(0, 3).to_upper()
		away_s = away_s.substr(0, 3).to_upper()
	var score := "%s %d-%d %s  %s" % [home_s, sim.home_score, sim.away_score, away_s, status]
	var fs := 16 if compact else 34
	draw_rect(Rect2(0, 0, w, fs + 6), Color(0, 0, 0, 0.65))
	draw_string(font, Vector2(6, fs), score, HORIZONTAL_ALIGNMENT_LEFT, w - 12, fs, UIKit.GOLD)
	if match_data["state"] == "live" and (not compact or Night.has_trinket("prismaticos")):
		var pr: Dictionary = sim.pressure()
		var bw := w * (0.5 if compact else 0.6)
		var bx := (w - bw) * 0.5
		var by := h - (12 if compact else 34)
		var bh := 8.0 if compact else 16.0
		draw_rect(Rect2(bx - 2, by - 2, bw + 4, bh + 4), Color(0, 0, 0, 0.7))
		draw_rect(Rect2(bx, by, bw, bh), Color("#2b5cad") if int(match_data["index"]) == 0 else Color("#e8b628"))
		draw_rect(Rect2(bx, by, bw * float(pr["home_share"]), bh), Color("#b8322a") if int(match_data["index"]) == 0 else Color("#e0e0e0"))
		if not compact:
			var lbl := "PRESIÓN"
			if Night.level("buho") >= 2:
				lbl = "GOL EN 10'  %d%% · %d%%" % [int(pr["home_10"] * 100), int(pr["away_10"] * 100)]
			draw_string(font, Vector2(bx, by - 6), lbl, HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color.WHITE)
	if compact and match_data["state"] == "pre":
		draw_rect(Rect2(0, h - 20, w, 20), Color(0, 0, 0, 0.6))
		draw_string(font, Vector2(6, h - 5), "PRÓXIMO PARTIDO", HORIZONTAL_ALIGNMENT_LEFT, w - 12, 15, Color.WHITE)
