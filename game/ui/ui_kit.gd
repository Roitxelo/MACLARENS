class_name UIKit
extends RefCounted

## Piezas de interfaz comunes: tipografías, paleta y botones con el estilo
## del kit visual v1 (pantallas verde azulado, papel envejecido, latón).

const FONT_UI := preload("res://assets/fonts/Jersey10-Regular.ttf")
const FONT_SCREEN := preload("res://assets/fonts/VT323-Regular.ttf")

const INK := Color("#1a0f0a")
const WOOD := Color("#3b2416")
const WOOD_LIGHT := Color("#5a3822")
const GOLD := Color("#f0bd54")
const CREAM := Color("#f0dca9")
const SCREEN_BG := Color("#0b2424")
const SCREEN_PANEL := Color("#103231")
const SCREEN_LINE := Color("#397d77")
const SCREEN_TEXT := Color("#a8e8d6")
const RED := Color("#c94b3b")
const GREEN := Color("#57b85a")
const PAPER := Color("#e6d3a8")
const PAPER_DARK := Color("#cdb684")
const PAPER_INK := Color("#2b1d12")
const PAPER_RED := Color("#9d302b")

static func box(bg: Color, border: Color = Color.TRANSPARENT, width: int = 0, radius: int = 2, pad: int = 6) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(radius)
	s.content_margin_left = pad
	s.content_margin_right = pad
	s.content_margin_top = pad * 0.5
	s.content_margin_bottom = pad * 0.5
	return s

static func label(text: String, size: int = 18, color: Color = CREAM, screen_font: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_override("font", FONT_SCREEN if screen_font else FONT_UI)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l

static func shadow(l: Label) -> Label:
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	l.add_theme_constant_override("shadow_offset_x", 2)
	l.add_theme_constant_override("shadow_offset_y", 2)
	return l

static func place(c: Control, rect: Rect2) -> Control:
	c.position = rect.position
	c.size = rect.size
	# Las etiquetas aún sin autowrap crecen hasta su texto; se reaplica el
	# tamaño al final del frame, cuando ya tienen su configuración completa.
	c.set_deferred("size", rect.size)
	return c

## Botón principal. kind: "gold", "red", "green", "teal", "wood", "paper".
static func button(text: String, kind: String = "gold", size: int = 20, screen_font: bool = false) -> Button:
	var b := Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_font_override("font", FONT_SCREEN if screen_font else FONT_UI)
	b.add_theme_font_size_override("font_size", size)
	var bg := GOLD
	var fg := INK
	var border := Color("#8a5a1c")
	match kind:
		"red":
			bg = Color("#b8402f"); fg = CREAM; border = Color("#6e2016")
		"green":
			bg = Color("#3f9a4a"); fg = Color("#eaffd8"); border = Color("#1f5a27")
		"teal":
			bg = SCREEN_PANEL; fg = SCREEN_TEXT; border = SCREEN_LINE
		"wood":
			bg = WOOD; fg = GOLD; border = Color("#8a6a3c")
		"paper":
			bg = PAPER; fg = PAPER_INK; border = Color("#8a7350")
	b.add_theme_stylebox_override("normal", box(bg, border, 3, 3, 10))
	b.add_theme_stylebox_override("hover", box(bg.lightened(0.15), GOLD if kind != "gold" else CREAM, 3, 3, 10))
	b.add_theme_stylebox_override("pressed", box(bg.darkened(0.2), border, 3, 3, 10))
	b.add_theme_stylebox_override("disabled", box(bg.darkened(0.5), border.darkened(0.4), 3, 3, 10))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.add_theme_color_override("font_color", fg)
	b.add_theme_color_override("font_hover_color", fg)
	b.add_theme_color_override("font_pressed_color", fg)
	b.add_theme_color_override("font_disabled_color", fg.darkened(0.45))
	return b

## Zona interactiva invisible sobre el arte. Al pasar el ratón se enmarca
## y muestra una etiqueta con su nombre para que el bar se lea sin menús.
static func hotspot(parent: Control, rect: Rect2, caption: String) -> Button:
	var b := Button.new()
	b.position = rect.position
	b.size = rect.size
	b.focus_mode = Control.FOCUS_NONE
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("hover", box(Color(1, 0.85, 0.4, 0.08), GOLD, 3, 4))
	b.add_theme_stylebox_override("pressed", box(Color(1, 0.85, 0.4, 0.16), GOLD, 3, 4))
	parent.add_child(b)
	var tag := label(caption, 17, INK)
	tag.add_theme_stylebox_override("normal", box(GOLD, Color("#8a5a1c"), 2, 2, 8))
	tag.visible = false
	tag.z_index = 20
	parent.add_child(tag)
	b.mouse_entered.connect(func():
		tag.visible = true
		tag.reset_size()
		var p := rect.position + Vector2(rect.size.x * 0.5 - tag.size.x * 0.5, -tag.size.y - 4)
		if p.y < 64:
			p.y = rect.position.y + rect.size.y + 4
		p.x = clampf(p.x, 6, 1274 - tag.size.x)
		tag.position = p)
	b.mouse_exited.connect(func(): tag.visible = false)
	b.visibility_changed.connect(func(): if not b.visible: tag.visible = false)
	return b

static func panel(parent: Control, rect: Rect2, bg: Color, border: Color = Color.TRANSPARENT, width: int = 0) -> Panel:
	var p := Panel.new()
	p.position = rect.position
	p.size = rect.size
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p.add_theme_stylebox_override("panel", box(bg, border, width, 3))
	parent.add_child(p)
	return p

static func texture_rect(tex: Texture2D, rect: Rect2 = Rect2(0, 0, 1280, 720)) -> TextureRect:
	var t := TextureRect.new()
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	t.texture = tex
	t.position = rect.position
	t.size = rect.size
	t.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return t

## Retrato recortado de la hoja de personajes (character_lineup_v1).
static func portrait(who: String) -> AtlasTexture:
	var a := AtlasTexture.new()
	a.atlas = preload("res://assets/concept/character_lineup_v1.png")
	match who:
		"cortado": a.region = Rect2(40, 50, 280, 300)
		"borracho", "chencho": a.region = Rect2(400, 90, 300, 300)
		"lucia": a.region = Rect2(760, 70, 260, 280)
		"buho": a.region = Rect2(1060, 70, 230, 260)
		_: a.region = Rect2(1390, 50, 270, 270)  # tino
	return a

static func money_text(v: int) -> String:
	return "%d €" % v
