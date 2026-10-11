extends Control

## Resumen final de la campaña para compartir (review 05). Los textos salen de
## GameTexts.campaign_summary(); "GUARDAR IMAGEN" deja un PNG en el escritorio.

const BAR := preload("res://assets/concept/mclarens_bar_master_v1.png")

var main: Control
var args: Dictionary
var saved_label: Label
var buttons: Array = []

func _ready() -> void:
	var d := GameTexts.campaign_summary()
	add_child(UIKit.texture_rect(BAR))
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.72)
	dim.size = size
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(dim)
	UIKit.panel(self, Rect2(150, 40, 980, 590), Color("#1e120b"), UIKit.GOLD, 3)
	var logo := UIKit.shadow(UIKit.label("McLARENS · La última combinada", 22, Color("#d8c8a8")))
	UIKit.place(logo, Rect2(150, 54, 980, 28))
	logo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(logo)
	var title := UIKit.shadow(UIKit.label(d["title"], 46, UIKit.GOLD if d["won"] else Color("#ff8a70")))
	UIKit.place(title, Rect2(150, 84, 980, 56))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(title)
	var sub := UIKit.label(d["subtitle"], 22, UIKit.CREAM)
	UIKit.place(sub, Rect2(150, 140, 980, 30))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(sub)
	# Cuatro cifras grandes
	for i in d["big"].size():
		var x: float = 190.0 + i * 228.0
		UIKit.panel(self, Rect2(x, 186, 210, 104), Color("#2a1a10"), Color("#8a6a3c"), 2)
		var v := UIKit.label(d["big"][i][1], 36, UIKit.GOLD, true)
		UIKit.place(v, Rect2(x, 196, 210, 50))
		v.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(v)
		var k := UIKit.label(d["big"][i][0], 16, Color("#d8c8a8"))
		UIKit.place(k, Rect2(x, 252, 210, 26))
		k.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(k)
	var best := UIKit.label(d["best"], 20, UIKit.CREAM)
	UIKit.place(best, Rect2(190, 304, 900, 30))
	best.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	best.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(best)
	# Juegos y gente
	var y := 348.0
	for row in d["games"]:
		var k := UIKit.label(row[0].to_upper(), 20, UIKit.GOLD)
		UIKit.place(k, Rect2(210, y, 160, 28))
		add_child(k)
		var v := UIKit.label(row[1], 20, UIKit.CREAM, true)
		UIKit.place(v, Rect2(370, y, 300, 28))
		add_child(v)
		y += 34
	var px := 700.0
	for who in ["buho", "cortado", "chencho", "tino"]:
		var pic := UIKit.texture_rect(UIKit.portrait(who), Rect2(px, 350, 90, 90))
		pic.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(pic)
		var lv := UIKit.label("Nv %d" % Night.level(who), 18, UIKit.GOLD)
		UIKit.place(lv, Rect2(px, 442, 90, 24))
		lv.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(lv)
		px += 100
	var q := UIKit.label(d["quote"], 19, Color("#d8c8a8"))
	UIKit.place(q, Rect2(190, 500, 900, 30))
	q.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(q)
	saved_label = UIKit.label("", 16, Color("#9ff59a"))
	UIKit.place(saved_label, Rect2(190, 540, 900, 50))
	saved_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	saved_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(saved_label)
	var save := UIKit.button("GUARDAR IMAGEN", "gold", 22)
	UIKit.place(save, Rect2(200, 645, 280, 60))
	save.pressed.connect(_save_image)
	add_child(save)
	var again := UIKit.button("OTRA CAMPAÑA", "wood", 22)
	UIKit.place(again, Rect2(500, 645, 280, 60))
	again.pressed.connect(func():
		Night.new_campaign()
		main.go("title"))
	add_child(again)
	var quit := UIKit.button("SALIR DEL BAR", "wood", 22)
	UIKit.place(quit, Rect2(800, 645, 280, 60))
	quit.pressed.connect(func(): get_tree().quit())
	add_child(quit)
	buttons = [save, again, quit]

## Guarda la pantalla (sin botones) como PNG en el escritorio, o en la carpeta
## de datos del juego si no hay escritorio.
func _save_image() -> void:
	for b in buttons:
		b.visible = false
	saved_label.text = ""
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	for b in buttons:
		b.visible = true
	var dir := OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	if dir == "" or not DirAccess.dir_exists_absolute(dir):
		dir = OS.get_user_data_dir()
	var path := dir.path_join("McLarens_resultado_%s.png" % Time.get_datetime_string_from_system().replace(":", "-"))
	var err := img.save_png(path)
	saved_label.text = ("Guardada en %s" % path) if err == OK else "No se pudo guardar la imagen."
