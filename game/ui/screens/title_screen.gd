extends Control

## Portada: la deuda con Tino y lo que ofrece la noche.

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(BAR))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.72)
	dim.size = size
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	var title := UIKit.shadow(UIKit.label("McLARENS", 92, UIKit.GOLD))
	UIKit.place(title, Rect2(0, 36, 1280, 110))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := UIKit.shadow(UIKit.label("La última combinada", 30, UIKit.CREAM))
	UIKit.place(sub, Rect2(0, 140, 1280, 40))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)
	var pic := UIKit.texture_rect(UIKit.portrait("tino"), Rect2(110, 210, 240, 240))
	pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(pic)
	var note := UIKit.label("Le debes 500 € a Tino.\nViene a cobrar a las 02:00.\nTienes 100 € y toda la noche.", 24, UIKit.PAPER_INK)
	note.add_theme_stylebox_override("normal", UIKit.box(Color("#efe2c4"), Color("#6b4f30"), 3, 4, 14))
	UIKit.place(note, Rect2(80, 460, 300, 120))
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(note)
	var list := UIKit.label("", 22, UIKit.CREAM)
	list.text = "\n".join([
		"MÁQUINA · Fútbol (19:00 y 22:30) y 10 carreras de caballos.",
		"EL BÚHO te enseña quién aprieta en el partido y, en Nv3, te deja tirar un penalti.",
		"EL CORTADO te deja arrear a tu caballo en plena carrera (timing).",
		"EL CHENCHO juega a Mayor o menor: cuanto más borracho, peor cuenta las cartas.",
		"TINO te reta al billar: tiros imposibles. Gánale y sube la apuesta... y baja tu deuda.",
		"LUCÍA · Rondas para subir de nivel a tu gente y objetos que mejoran tu juego.",
		"RACHA · Gana seguido y el beneficio crece un poco (hasta x1,5).",
		"SUERTE · Tres corazonadas: pulso firme, arreo perfecto, engañar al portero, ver la carta.",
	])
	UIKit.place(list, Rect2(430, 214, 790, 330))
	list.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	list.add_theme_constant_override("line_spacing", 8)
	add_child(list)
	var hint := UIKit.label("El reloj corre solo: la noche dura unos 13 minutos reales. Arriba a la derecha puedes pausar (P) o acelerar (x2, x4). ESC vuelve al bar.", 17, Color("#cbb98f"))
	UIKit.place(hint, Rect2(430, 552, 790, 40))
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(hint)
	var start := UIKit.button("ABRIR EL BAR · 18:00", "red", 30)
	UIKit.place(start, Rect2(640, 610, 380, 70))
	start.pressed.connect(func(): main.go("bar"))
	add_child(start)
	var small := UIKit.label("Juego de ficción. Ningún caballo fue sobornado.", 14, Color("#8a7a5a"))
	UIKit.place(small, Rect2(80, 690, 600, 24))
	add_child(small)
