# Tablero de tareas

> Única fuente del estado de las tareas (ver `WORKFLOW.md` v2).
> Estados: `Pendiente` · `En curso` · `Hecho` (listo para el playtest) · `Bloqueado (motivo)`. Lo aprueba Roi jugando el hito.
> Números: `Tnn` (Roi y las reviews) · `Cnn` (los crea Claude) · `Xnn` (los crea Codex).

## H0 — Validar la campaña integrada · **Jugado por Roi** (`REVIEW_03_ROI.md`)

Congelado: no entra nada nuevo, solo bloqueos, incoherencias de la economía y textos engañosos. **Sale una versión concreta para que Roi juegue en `F:`.**

| Id | Tarea | Dueño | Estado | Hecho cuando |
|---|---|---|---|---|
| C01 | Simular las 5 noches con estrategias deportivas fijas (siempre favorito, siempre empate, siempre al que va ganando en directo) | Claude | Hecho | Ninguna estrategia fija gana la campaña sola; resultado en `BALANCE.md` |
| C02 | Coherencia económica de la campaña: el perdón de Tino (100 €) no puede cubrir una cuota entera | Claude | Hecho | Regla corregida, simulada y anotada en `DECISIONS.md` |
| C03 | Prueba automática de la campaña: pagar, pasar de noche conservando dinero, niveles y objetos, y que la quinta noche cierre | Claude | Hecho | `campaign_test` en `tools/run_tests` (rápidas) |
| C04 | Textos de la pantalla final como datos ("Empezaste con", "Al cierre", "Tino cobra", "Te quedan") | Claude | Hecho | En `game/data/texts.gd`; aviso a Codex |
| X01 | Jugar una campaña completa (o hasta perder), revisar todas las capturas y apuntar problemas por noche y pantalla | Codex | Hecho | `docs/reviews/PLAYTEST_02_CODEX.md` |
| X02 | Montar en la pantalla final los textos de C04 (la pantalla pasa a Codex) | Codex | Hecho | El cierre se entiende sin leer el código |
| X05 | Limpiar los avisos al cambiar de noche | Codex | Hecho | La noche empieza a las 18:00 sin mensajes caducados de la anterior |

## H1 — Que se entienda y se vea (en curso, sale de `REVIEW_03_ROI.md`)

| Id | Tarea | Dueño | Estado | Hecho cuando |
|---|---|---|---|---|
| T04 | Ayuda contextual la primera vez que se entra en cada sitio y se ve cada mecánica (presión, arreo, penalti, cartas, billar) | Claude (textos) + Codex (UI) | Hecho | Un jugador nuevo descubre las mecánicas a tiempo sin leer la portada |
| C05 | Portada breve: 3 líneas y a jugar; las reglas pasan a la ayuda contextual | Claude (textos) + Codex (UI) | Hecho | Portada legible en 10 s |
| T15 | Repaso de tono y erratas en todos los textos | Claude | Hecho (datos y avisos de Claude) | |
| T23 | Botones de la máquina: digitales de los 90 (LCD, plástico), chapuceros pero claros; que se vea el tope de 50 € | Codex | Hecho | Roi da el visto bueno a una captura |
| X03 | La presión del fútbol, explicada con una frase y un icono en la máquina y la TV | Codex | Hecho | Roi la entiende sin preguntar |
| X04 | Tienda de Lucía: cada ronda dice qué desbloquea (`Catalog.CHARACTERS[*].short`) | Codex | Hecho | |
| T20 | Desbordamientos de texto (símbolo `€` suelto en el resumen de apuesta hípica) | Codex | Hecho | Ninguna captura tiene texto partido |
| T07 | Poder salir de una mano de cartas (ESC con confirmación) | Codex | Hecho | El reloj no se queda en pausa y el dinero cuadra |
| C06 | Billar: guía corta de base (hasta el primer contacto y la salida de la bola tocada); la Tiza la alarga y la corazonada enseña el tiro entero | Claude | Hecho | Roi: "ni fácil ni imposible" sin objetos; la corazonada vuelve a tener sentido |
| C07 | Textos mínimos como datos para portada, libreta y periódico (`GameTexts`): una línea por cosa, pensados para ir con iconos | Claude | Hecho | Ninguna pantalla con más de ~6 líneas de texto seguido |
| X06 | Cartas: las que han salido, bocarriba, pequeñas y agrupadas por número, en la mesa del Chencho | Codex | Hecho | Se puede contar de un vistazo |
| X07 | Rediseño visual de portada, libreta y periódico: menos texto, más iconos/retratos/cartas; usan los textos de C07 | Codex | Hecho | Roi las encuentra atractivas |
| T01 | Calibrar los minijuegos jugando (arreo, penalti, billar con guía) | Codex (arreo, penalti) + Claude (billar) | Pendiente | Billar Nv1 en 1-3 intentos, el arreo perfecto ~1 de cada 3 |

## H2 — Móvil (Godot → Android, 0 €; ver `docs/design/MOBILE.md`)

| Id | Tarea | Dueño | Estado |
|---|---|---|---|
| T03 | Export a Windows (`.exe` en `builds/`, fuera del repo) | Codex | Pendiente |
| T29 | Preset de Android y `.apk` de prueba | Codex | Pendiente |
| T30 | Pasada táctil: botones para ESPACIO, ← →, P y ESC; textos de 20 px o más; toques de 48 px o más | Codex (pantallas) + Claude (billar) | Pendiente |
| T31 | Probar el `.apk` en el móvil de Roi | Roi | Pendiente |

## H3 — Audio y acabado

| Id | Tarea | Dueño | Estado |
|---|---|---|---|
| T02 | Audio: ambiente, gol, silbato, salida, cartas, monedas, billar, clics; bus música/efectos | Codex | Pendiente |
| T09 | *Juice*: dinero animado con origen y signo, destellos, sacudidas | Codex | Pendiente |
| T10 | Aviso grande al subir y al romperse la racha | Codex | Pendiente |
| T11 | Cierre más rico: dinero por hora y mejor jugada | Claude (datos) + Codex (UI) | Pendiente |
| T12 | Arte: quitar "CONFIANZA" del arte de Lucía; fondos secundarios antiguos | Roi | Pendiente |
| T13 | Opciones: volumen, pantalla completa, velocidad por defecto | Codex | Pendiente |
| T14 | Optimizar `machine_screen.gd` si se nota | Codex | Pendiente |

## Ideas (necesitan el visto bueno de Roi)

- T17 Eventos del bar (el Chencho interrumpe, apagón, redada cómica).
- T18 Traducción al inglés.
- Más deportes en la TV de la barra (Roi, review 02).

## Hecho (pendiente de playtest de Roi salvo indicación)

- T05/T08 Equilibrio de una noche y prueba de la economía · T06 avisos por pantalla · T19 billar "Tiro imposible" · T21 venta en directo del fútbol
- **Review 02:** T22 bar en dos zonas · T24 libreta y periódico breves · T25 guía del billar · T26 campaña de 5 noches · T27 cada noche distinta + topes de la máquina · T28 plan móvil
