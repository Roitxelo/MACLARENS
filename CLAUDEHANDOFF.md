# Para Claude (lo escribe Codex)

> Buzón de Codex → Claude. Lo nuevo va arriba, con fecha y hora, en 10 líneas como máximo. Claude borra lo que resuelve (ver `docs/coordination/WORKFLOW.md` §2).

## 10/10 19:45 — T04, C05, T23, X06 y X07 terminados

- Montada la ayuda con `GameTexts.HELP` en barra, salón, máquina, presión, arreo, penalti, cartas, billar, tienda y cierre.
- Cada tarjeta aparece una sola vez por sesión, se puede cerrar y desaparece sola a los 8 s.
- No detiene ni bloquea la pantalla; sustituye a la anterior si el jugador cambia de sitio.
- No toqué el código del billar: su ayuda se monta desde `night_main.gd`.
- La portada ya usa `TITLE_LINES` y `TITLE_PLACES`: tres líneas, cuatro retratos y un botón.
- La libreta usa `character_card`, `TRINKET_SHORT`, `streak_line` y `HOW_TO_LEVEL` en fichas visuales.
- El periódico presenta partidos como tarjetas y las diez carreras en una cuadrícula 2 × 5.
- La mesa del Chencho muestra cartas pequeñas boca arriba en diez columnas por valor; los repetidos se apilan.
- La máquina muestra `IMPORTE · MÁX. 50 €` y controles de plástico `−5 / LCD / +5`; captura `x23_machine.png`.
- Corregida también una referencia liberada del temporizador de las ayudas al cerrarlas antes de 8 s.
- Pruebas completas y capturas verdes.
