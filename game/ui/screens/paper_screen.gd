extends Control

## Diario Gol Local: cartelera de la noche con horarios, cuotas y resultados.

var main: Control
var args: Dictionary

func _ready() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#2a170d")
	bg.size = size
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	for i in 12:
		var plank := ColorRect.new()
		plank.color = Color("#33200f") if i % 2 == 0 else Color("#2c1a0d")
		UIKit.place(plank, Rect2(0, i * 60, 1280, 58))
		plank.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(plank)
	var paper := UIKit.panel(self, Rect2(60, 112, 1160, 530), UIKit.PAPER, Color("#8a7350"), 3)
	paper.add_theme_stylebox_override("panel", UIKit.box(UIKit.PAPER, Color("#8a7350"), 3, 1))
	var title := UIKit.label("DIARIO GOL LOCAL", 46, UIKit.PAPER_INK)
	UIKit.place(title, Rect2(90, 118, 600, 56))
	add_child(title)
	var date := UIKit.label("Cartelera de la noche en el McLarens", 20, UIKit.PAPER_RED)
	UIKit.place(date, Rect2(560, 136, 640, 30))
	date.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(date)
	var rule := ColorRect.new()
	rule.color = UIKit.PAPER_RED
	UIKit.place(rule, Rect2(84, 176, 1112, 3))
	add_child(rule)
	var mid := ColorRect.new()
	mid.color = UIKit.PAPER_DARK
	UIKit.place(mid, Rect2(632, 190, 2, 430))
	add_child(mid)

	var y := _section("FÚTBOL · TELE DE LA BARRA", 90, 190.0)
	for m in Night.football.matches:
		var sim: MatchSimulator = m["sim"]
		var head := UIKit.label("%s · %s - %s" % [Night.clock_text(m["kickoff"]), m["home"], m["away"]], 24, UIKit.PAPER_INK)
		UIKit.place(head, Rect2(90, y, 530, 30))
		add_child(head)
		var status := ""
		match m["state"]:
			"pre": status = "La casa paga:  1 → %.2f    X → %.2f    2 → %.2f" % [m["odds"]["1"], m["odds"]["X"], m["odds"]["2"]]
			"live": status = "EN JUEGO · minuto %d · %d-%d" % [int(m["minute"]), sim.home_score, sim.away_score]
			_: status = "FINAL: %d-%d" % [sim.home_score, sim.away_score]
		var st := UIKit.label(status, 20, UIKit.PAPER_RED)
		UIKit.place(st, Rect2(90, y + 32, 530, 26))
		add_child(st)
		y += 76
	y = _section("ESTA NOCHE", 90, y + 10)
	var tips := GameTexts.tonight_lines()
	var tl := UIKit.label("\n".join(tips), 20, Color("#3b2a1a"))
	UIKit.place(tl, Rect2(90, y, 530, 140))
	tl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(tl)

	y = _section("HÍPICA · TELE DEL SALÓN", 650, 190.0)
	var lines: Array = []
	for r in Night.races.races:
		var txt := ""
		if r["state"] == "done":
			var w := Night.races.winner(r)
			txt = "C%d %s  ganó %s (%.1f)" % [int(r["index"]) + 1, Night.clock_text(r["start"]), r["horses"][w]["name"], r["horses"][w]["odds"]]
		else:
			var f := Night.races.favourite(r)
			txt = "C%d %s  favorito %s (%.1f)%s" % [int(r["index"]) + 1, Night.clock_text(r["start"]), r["horses"][f]["name"], r["horses"][f]["odds"], "  EN CARRERA" if r["state"] == "running" else ""]
		lines.append(txt)
	var fav := UIKit.label("\n".join(lines), 21, UIKit.PAPER_INK, true)
	UIKit.place(fav, Rect2(650, y, 540, 300))
	add_child(fav)

	var back := UIKit.button("DEJAR EL PERIÓDICO", "wood", 20)
	UIKit.place(back, Rect2(24, 656, 260, 46))
	back.pressed.connect(func(): main.go("bar"))
	add_child(back)
	var hint := UIKit.shadow(UIKit.label("Leer es gratis, pero el reloj sigue corriendo.", 18, UIKit.CREAM))
	UIKit.place(hint, Rect2(300, 664, 600, 30))
	add_child(hint)

func _section(text: String, x: float, y: float) -> float:
	var l := UIKit.label(text, 20, UIKit.CREAM)
	l.add_theme_stylebox_override("normal", UIKit.box(UIKit.PAPER_RED, Color.TRANSPARENT, 0, 1, 8))
	l.position = Vector2(x, y)
	add_child(l)
	return y + 36
