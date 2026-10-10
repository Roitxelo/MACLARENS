extends Control

## Salón del fondo: separa los juegos de mesa y el canal hípico de la barra.

const SALON := preload("res://assets/concept/mclarens_salon_v1.png")
const RaceTrack := preload("res://ui/widgets/race_track.gd")

var main: Control
var args: Dictionary

func _ready() -> void:
	add_child(UIKit.texture_rect(SALON))

	var tv := RaceTrack.new()
	tv.compact = true
	UIKit.place(tv, Rect2(154, 55, 220, 135))
	tv.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(tv)

	UIKit.hotspot(self, Rect2(145, 45, 240, 180), "TV hípica · Ver los caballos").pressed.connect(func(): main.go("race_tv"))
	UIKit.hotspot(self, Rect2(15, 390, 470, 300), "Mesa del Chencho · Mayor o menor (Nv%d)" % Night.level("chencho")).pressed.connect(func(): main.go("cards"))
	UIKit.hotspot(self, Rect2(485, 330, 625, 320), "Billar · Tino (Nv%d)" % Night.level("tino")).pressed.connect(func(): main.go("billar_lobby"))

	var bar_btn := UIKit.button("←  VOLVER A LA BARRA", "wood", 19)
	UIKit.place(bar_btn, Rect2(1060, 170, 200, 54))
	bar_btn.tooltip_text = "Fútbol, apuestas, Lucía, periódico y libreta"
	bar_btn.pressed.connect(func(): main.go("bar"))
	add_child(bar_btn)

	var guide := UIKit.shadow(UIKit.label("SALÓN · CABALLOS  /  BILLAR  /  CARTAS", 20, UIKit.CREAM))
	guide.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	guide.add_theme_stylebox_override("normal", UIKit.box(Color(0.05, 0.03, 0.02, 0.82), UIKit.GOLD.darkened(0.35), 2, 3, 8))
	UIKit.place(guide, Rect2(365, 674, 550, 38))
	add_child(guide)
