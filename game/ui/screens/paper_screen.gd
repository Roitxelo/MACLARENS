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
		_football_card(m, y)
		y += 96
	y = _section("ESTA NOCHE", 90, y + 4)
	var tips := GameTexts.tonight_lines()
	var tl := UIKit.label("\n".join(tips), 20, Color("#3b2a1a"))
	UIKit.place(tl, Rect2(90, y, 530, 140))
	tl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(tl)

	y = _section("HÍPICA · TELE DEL SALÓN", 650, 190.0)
	for i in Night.races.races.size():
		var col := i % 2
		var row := i / 2
		_race_card(Night.races.races[i], Rect2(650 + col * 272, y + row * 76, 260, 66))

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

func _football_card(match_data: Dictionary, y: float) -> void:
	var card := UIKit.panel(self, Rect2(90, y, 530, 86), Color("#f0e3c3"), Color("#c6a875"), 1)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var time := UIKit.label(Night.clock_text(match_data["kickoff"]), 22, UIKit.CREAM, true)
	time.add_theme_stylebox_override("normal", UIKit.box(UIKit.PAPER_RED, Color.TRANSPARENT, 0, 1, 8))
	UIKit.place(time, Rect2(100, y + 13, 82, 40))
	time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(time)
	var teams := UIKit.label("%s — %s" % [match_data["home"], match_data["away"]], 22, UIKit.PAPER_INK, true)
	UIKit.place(teams, Rect2(196, y + 8, 410, 30))
	add_child(teams)
	var sim: MatchSimulator = match_data["sim"]
	var status := ""
	match match_data["state"]:
		"pre": status = "1 %.2f    X %.2f    2 %.2f" % [match_data["odds"]["1"], match_data["odds"]["X"], match_data["odds"]["2"]]
		"live": status = "EN JUEGO · %d' · %d-%d" % [int(match_data["minute"]), sim.home_score, sim.away_score]
		_: status = "FINAL · %d-%d" % [sim.home_score, sim.away_score]
	var state := UIKit.label(status, 18, UIKit.PAPER_RED, true)
	UIKit.place(state, Rect2(196, y + 44, 410, 26))
	add_child(state)

func _race_card(race: Dictionary, rect: Rect2) -> void:
	var card := UIKit.panel(self, rect, Color("#f0e3c3"), Color("#c6a875"), 1)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var badge := UIKit.label("C%d" % (int(race["index"]) + 1), 18, UIKit.CREAM, true)
	badge.add_theme_stylebox_override("normal", UIKit.box(UIKit.PAPER_RED, Color.TRANSPARENT, 0, 1, 7))
	UIKit.place(badge, Rect2(rect.position.x + 8, rect.position.y + 9, 44, 44))
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(badge)
	var horse_index := Night.races.winner(race) if race["state"] == "done" else Night.races.favourite(race)
	var horse: Dictionary = race["horses"][horse_index]
	var horse_name := UIKit.label(str(horse["name"]), 17, UIKit.PAPER_INK, true)
	UIKit.place(horse_name, Rect2(rect.position.x + 60, rect.position.y + 6, 192, 24))
	add_child(horse_name)
	var state := "GANÓ" if race["state"] == "done" else ("EN CARRERA" if race["state"] == "running" else "FAVORITO")
	var detail := UIKit.label("%s · %s · %.1f" % [Night.clock_text(race["start"]), state, horse["odds"]], 14, UIKit.PAPER_RED)
	UIKit.place(detail, Rect2(rect.position.x + 60, rect.position.y + 34, 192, 22))
	add_child(detail)
