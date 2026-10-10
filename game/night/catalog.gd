class_name Catalog
extends RefCounted

## Personajes (niveles) y objetos. Filosofía: las mejoras no regalan dinero,
## dan herramientas que premian jugar bien (leer el partido, arrear a tiempo,
## contar cartas, dominar el futbolín). Los efectos se aplican buscando el id.

const MAX_LEVEL := 3
const MAX_TRINKETS := 5

const CHARACTERS := {
	"buho": {
		"name": "El Búho", "game": "football", "role": "Te ayuda en el fútbol",
		"rounds": [0, 35, 70],
		"levels": [
			"Te enseña el medidor de PRESIÓN: quién aprieta ahora. La casa tarda en verlo.",
			"La presión con porcentajes de gol a 10 minutos y cobro anticipado sin comisión.",
			"Una vez por partido te deja tirar un PENALTI tú mismo (minijuego de puntería).",
		],
	},
	"cortado": {
		"name": "El Cortado", "game": "horse", "role": "Te ayuda con los caballos",
		"rounds": [0, 35, 70],
		"levels": [
			"Apuestas a ganador.",
			"ARREAR: en la TV 2, durante la carrera de tu caballo, 3 arreos de timing.",
			"5 arreos por carrera y apuestas a COLOCADO (1.º o 2.º, cuota/3).",
		],
	},
	"chencho": {
		"name": "El Chencho", "game": "cards", "role": "Rival en Mayor o menor",
		"rounds": [0, 25, 60],
		"levels": [
			"Sobrio: calcula bien las cuotas. Mesa de 20 € como máximo.",
			"Contento: mesa de 40 € y un SEGURO por mano (si fallas, salvas la mitad).",
			"Como una cuba: mesa de 60 € y paga como si la baraja estuviera entera. Cuenta cartas.",
		],
	},
	"tino": {
		"name": "Tino", "game": "billar", "role": "Rival en el billar (tiro imposible)",
		"rounds": [],
		"levels": [
			"Calentamiento: paga 1 a 1, hasta 30 €.",
			"Con truco (banda, carambola): paga 3 a 2, hasta 60 €.",
			"Imposibles: paga 2 a 1, hasta 100 €. La 1.ª vez que le ganas, te perdona 100 €.",
		],
	},
}

## Billar: apuesta máxima y cuánto paga Tino por € apostado (beneficio) en cada nivel.
## Tino solo juega TINO_SERIES series por noche: el billar da para vivir, no para
## hacerse rico (con la guía de trayectoria, el jugador hábil acierta mucho).
const TINO_MAX_STAKE := [30, 60, 100]
const TINO_PAYOUT := [1.0, 1.5, 2.0]
const TINO_SERIES := 3

## Lo que cobras al ganar la serie (apuesta incluida).
static func tino_gross(level: int, stake: int) -> int:
	return stake + int(round(stake * float(TINO_PAYOUT[clampi(level, 1, 3) - 1])))

static func tino_pay_text(level: int) -> String:
	return ["1 a 1", "3 a 2", "2 a 1"][clampi(level, 1, 3) - 1]
const CHENCHO_MAX := [20, 40, 60]
const CORTADO_WHIPS := [0, 3, 5]

const TRINKETS := {
	"tiza": {"name": "Tiza azul", "price": 20, "game": "billar",
		"text": "La guía del billar se ve un rebote más lejos y sigue más a la bola tocada."},
	"taco": {"name": "Taco de nácar", "price": 25, "game": "billar",
		"text": "La barra de potencia sube más despacio: más control del golpe."},
	"guante": {"name": "Guante de billar", "price": 20, "game": "billar",
		"text": "Las flechas afinan la puntería cuatro veces más fino."},
	"repeticion": {"name": "Bola de la suerte", "price": 30, "game": "billar",
		"text": "Una vez por serie de billar puedes repetir un tiro fallado."},
	"fusta": {"name": "Fusta nueva", "price": 25, "game": "horse",
		"text": "+2 arreos por carrera y la zona verde es más ancha."},
	"gafas": {"name": "Gafas de culo de vaso", "price": 25, "game": "horse",
		"text": "Ves qué caballo viene en forma (la casa no lo sabe)."},
	"herradura": {"name": "Herradura oxidada", "price": 20, "game": "horse",
		"text": "Si tu caballo llega 2.º a ganador, recuperas la apuesta (hasta 20 €)."},
	"silbato": {"name": "Silbato de árbitro", "price": 25, "game": "football",
		"text": "En el penalti el portero tapa menos portería."},
	"prismaticos": {"name": "Prismáticos", "price": 20, "game": "football",
		"text": "El medidor de presión también aparece en la tele del bar."},
	"chuleta": {"name": "Chuleta", "price": 25, "game": "cards",
		"text": "En Mayor o menor ves cuántas cartas mayores y menores quedan."},
	"moneda": {"name": "Moneda de dos caras", "price": 25, "game": "cards",
		"text": "Una vez por noche, un fallo en las cartas cuenta como empate."},
	"calcetin": {"name": "Calcetín de la suerte", "price": 20, "game": "any",
		"text": "La primera derrota de cada racha no la rompe."},
	"trebol": {"name": "Trébol de plástico", "price": 20, "game": "any",
		"text": "+1 corazonada máxima y +1 ahora mismo."},
	"chapa": {"name": "Chapa de Lucía", "price": 15, "game": "any",
		"text": "Las rondas en la barra cuestan un 40 % menos."},
}

const GAME_NAMES := {"football": "Fútbol", "horse": "Caballos", "billar": "Billar", "cards": "Cartas"}

## Racha: +0,1 al multiplicador del BENEFICIO por victoria previa, máx. x1,5.
const STREAK_STEP := 0.1
const STREAK_CAP := 1.5

static func streak_mult(previous_wins: int) -> float:
	return minf(STREAK_CAP, 1.0 + STREAK_STEP * previous_wins)
