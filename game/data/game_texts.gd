class_name GameTexts
extends RefCounted

## Textos que ve el jugador, como datos (WORKFLOW v2: los escribe Claude, la
## pantalla de Codex solo los muestra). Cada función devuelve texto listo.

## Cierre de la noche. Llamar ANTES de Night.pay_tino() para tener `bank`
## (dinero al cierre) y `quota`; `paid` es lo que devuelve pay_tino().
static func end_summary(bank: int, quota: int, paid: bool, reason: String) -> Dictionary:
	var n := Night.night_index + 1
	var last := Night.is_last_night()
	var start := Night.night_start_money
	var d := {
		"head": "NOCHE %d DE %d" % [n, Night.NIGHTS],
		"rows": [
			["EMPEZASTE CON", "%d €" % start],
			["AL CIERRE", "%d €" % bank],
			["TINO COBRA", "%d €" % quota],
			["TE QUEDAN", "%d €" % (bank - quota) if paid else "—"],
		],
		"today": "Hoy: %+d €" % (bank - start),
	}
	if paid and last:
		d["banner"] = "¡HAS SALDADO LA DEUDA!"
		d["verdict"] = "¡LIBRE! Tino cobra lo último."
		d["quote"] = "Cuenta saldada. Ha sido un placer... casi siempre."
		d["button"] = "EMPEZAR DE NUEVO"
	elif paid:
		d["banner"] = "TINO COBRA. SIGUES VIVO."
		d["verdict"] = "PAGADO. Mañana cobra %d €." % Night.quota(Night.night_index + 1)
		d["quote"] = "Hoy cumples. Mañana vuelvo, y traigo la libreta."
		d["button"] = "SIGUIENTE NOCHE"
	else:
		d["banner"] = "TINO NO ESTÁ CONTENTO"
		d["verdict"] = "Sin blanca antes de las 02:00." if reason == "broke" else "Faltan %d €." % (quota - bank)
		d["quote"] = "Tranquilo. Me quedo la bici, la tele y tu dignidad."
		d["button"] = "EMPEZAR DE NUEVO"
	return d

## Recuadro "ESTA NOCHE" del periódico.
static func tonight_lines() -> Array:
	var lines := ["Noche %d de %d. Tino cobra %d € a las 02:00." % [Night.night_index + 1, Night.NIGHTS, Night.debt]]
	if Night.is_last_night():
		lines.append("Es la última: paga y eres libre.")
	else:
		lines.append("Mañana cobrará %d €." % Night.quota(Night.night_index + 1))
	lines.append("Boletos de hasta %d €. Tino juega %d series de billar." % [Night.MAX_TICKET, Catalog.TINO_SERIES])
	return lines

# --- C05 · Portada -----------------------------------------------------------------

## Tres líneas y a jugar. Las reglas se explican al usarlas (HELP).
const TITLE_LINES := [
	"Le debes 1.800 € a Tino.",
	"Te los cobra en cinco noches, a las 02:00.",
	"Apuesta, juega y no te quedes corto.",
]

## Lo que hay en el bar, para dibujar con un icono o retrato cada uno.
## icon: clave sugerida para el dibujo (Codex decide el arte).
const TITLE_PLACES := [
	{"icon": "machine", "label": "Fútbol y caballos"},
	{"icon": "billar", "label": "Billar con Tino"},
	{"icon": "cards", "label": "Cartas con el Chencho"},
	{"icon": "lucia", "label": "Rondas y objetos"},
]

# --- C07 · Libreta (una línea por cosa) -----------------------------------------

## Ficha de un personaje para la libreta o la tienda.
static func character_card(who: String) -> Dictionary:
	var c: Dictionary = Catalog.CHARACTERS[who]
	var lv := Night.level(who)
	var d := {
		"name": c["name"],
		"game": GAME_WORD[c["game"]],
		"level": lv,
		"now": c["short"][lv - 1],
		"next": "",
		"how": "",
	}
	if lv < Catalog.MAX_LEVEL:
		d["next"] = c["short"][lv]
		d["how"] = "Gánale una serie" if who == "tino" else "Ronda · %d €" % Night.round_price(who)
	return d

const GAME_WORD := {"football": "Fútbol", "horse": "Caballos", "cards": "Cartas", "billar": "Billar"}

## Efecto de cada objeto en cinco palabras o menos.
const TRINKET_SHORT := {
	"tiza": "Guía del billar más larga",
	"taco": "Potencia más lenta",
	"guante": "Puntería más fina",
	"repeticion": "Repite un tiro fallado",
	"fusta": "+2 arreos, verde más ancho",
	"gafas": "Ves el caballo en forma",
	"herradura": "2.º puesto: recuperas la apuesta",
	"silbato": "Portero más pequeño",
	"prismaticos": "Presión también en la tele",
	"chuleta": "Cuenta de mayores y menores",
	"moneda": "Un fallo es empate (1/noche)",
	"calcetin": "Salva tu racha una vez",
	"trebol": "+1 corazonada",
	"chapa": "Rondas un 40 % más baratas",
}

## Racha en una línea.
static func streak_line() -> String:
	if Night.streak == 0:
		return "Sin racha. Gana con 10 € o más para empezarla."
	return "Racha de %d: el próximo premio, +%d %%." % [Night.streak, int(round((Catalog.streak_mult(Night.streak) - 1.0) * 100.0))]

const HOW_TO_LEVEL := "Invita a una ronda en la barra (una por noche). A Tino, gánale al billar."

## Por qué no se puede comprar algo ahora en la barra ("" si se puede).
static func round_block_reason(who: String) -> String:
	if Night.level(who) >= Catalog.MAX_LEVEL:
		return "Nivel máximo"
	if Night.rounds_today.has(who):
		return "Ya ha bebido hoy"
	if Night.money < Night.round_price(who):
		return "No te llega"
	return ""

static func trinket_block_reason() -> String:
	if Night.trinkets.size() >= Catalog.MAX_TRINKETS:
		return "Bolsillos llenos"
	if Night.trinkets_left_today() <= 0:
		return "Lucía no saca más hasta mañana"
	return ""

## Línea de la barra: cuántos objetos quedan hoy.
static func shop_limits_line() -> String:
	return "Hoy: %d de %d objetos · una ronda por cabeza" % [Night.trinkets_left_today(), Catalog.TRINKETS_PER_NIGHT]

# --- T04 · Ayuda la primera vez ----------------------------------------------------

## Una ayuda por sitio o mecánica: título + dos líneas como mucho. La pantalla
## la enseña la primera vez que se entra (o que aparece la mecánica).
const HELP := {
	"bar": ["LA BARRA", "Máquina, tele del fútbol, Lucía y el periódico.\nEl salón (billar, cartas, caballos) está al fondo."],
	"salon": ["EL SALÓN", "Tele de los caballos, billar con Tino y cartas con el Chencho."],
	"machine": ["LA MÁQUINA", "Elige partido o carrera, pon cuánto (máx. 50 €) y apuesta.\nEn el fútbol puedes vender el boleto en pleno partido."],
	"pressure": ["LA PRESIÓN", "La barra dice quién aprieta ahora. Quien aprieta suele marcar pronto,\ny la casa tarda en cambiar la cuota: ahí está tu ventaja."],
	"penalty": ["¡PENALTI!", "La mirilla se mueve: dispara pegado al palo.\nEl portero tapa un trozo al azar."],
	"whip": ["ARREAR", "Pulsa cuando la aguja pase por lo verde: tu caballo acelera.\nFuera de lo verde, se asusta."],
	"cards": ["MAYOR O MENOR", "¿La siguiente carta es mayor o menor? Cada acierto sube el bote.\nPlántate cuando quieras. Las cartas que han salido no vuelven."],
	"billar": ["TIRO IMPOSIBLE", "Tres mesas con misión: mete dos y ganas.\nApunta con la guía, mantén para cargar y suelta."],
	"shop": ["LA BARRA DE LUCÍA", "Las rondas suben de nivel a tu gente (una por noche cada uno);\nlos objetos dan ventajas (dos por noche). Todo se queda para mañana."],
	"end": ["A LAS 02:00", "Tino cobra la cuota de la noche. Si no llegas, se acaba."],
}
