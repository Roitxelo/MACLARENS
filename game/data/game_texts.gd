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
