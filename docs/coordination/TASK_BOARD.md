# Tablero de tareas

Estados: `Pendiente` · `En curso (dueño)` · `Hecho` · `Bloqueado (motivo)`.
Antes de empezar una tarea, ponla `En curso` en tu primer commit. Al terminar, `Hecho` + commit.
Dueño propuesto según `WORKFLOW.md`; se puede cambiar avisando aquí.

## P0 — Para entregar (jugable, presentable, sin sustos)

| Id | Tarea | Dueño | Estado | Hecho cuando |
|---|---|---|---|---|
| T01 | Probar jugando y calibrar los minijuegos: velocidad de la aguja del arreo (`race_screen.gd`), mirilla del penalti (`penalty_overlay.gd: SPEED`), dificultad del billar (tras T19) | Codex | Pendiente | El billar Nv1 se gana en 2-3 intentos, Nv3 cuesta; el arreo perfecto sale ~1 de cada 3 intentando; el penalti pegado al palo se consigue con práctica |
| T02 | Audio básico: ambiente de bar, gol, silbato, salida de caballos, cartas, monedas, golpes de billar, clic de botones. Bus de música/efectos | Codex | Pendiente | Cada acción importante suena; volumen ajustable en código |
| T03 | Export a Windows (preset + `.exe` en `builds/`, fuera del repo) | Codex | Pendiente | El `.exe` arranca en un PC sin Godot |
| T04 | Primera noche guiada: reducir el caos, destacar la siguiente acción y los hotspots, y mostrar ayuda contextual al entrar en cada sitio | Codex (UI) + Claude (textos) | Pendiente | Un jugador nuevo sabe qué atender ahora y entiende máquina, arreo, penalti, cartas y tienda sin leer el GDD ni la portada completa |
| T05 | Equilibrio de la deuda: aplicar la decisión 2+3 (200 € iniciales, arreo perfecto, baraja persistente Nv3 y segundo partido con más presión) y repetir la simulación | Claude + Codex | Hecho (continúa en T26, campaña) | Informe actualizado en `docs/design/BALANCE.md`: jugador al azar < 15 % de éxito, hábil 50-70 % |
| T06 | Avisos (toasts) que tapan contenido en carrera, lobby del billar y bar: moverlos o dar zona propia por pantalla | Codex | Hecho | Ninguna captura de `night_capture` tiene texto tapado |
| T07 | Poder salir de una mano de cartas (el billar ya trae botón de rendirse, T19) (ESC con confirmación) | Codex | Pendiente | Salir no deja el reloj en pausa ni el dinero inconsistente |
| T19 | Sustituir el futbolín por billar "Tiro imposible": Tino prepara tiros retorcidos (a banda, carambola, sin tocar la negra, tronera marcada) en series de 3; ganar 2 = ganas la apuesta. Objetos y corazonada nuevos | Claude | Hecho | Minijuego jugable, cada mesa con solución comprobada por un buscador automático, docs al día |
| T08 | Prueba de regresión de economía: test que verifica pagos, cobro, racha (tope x1,5), herradura, seguro del Chencho y perdón de Tino | Claude | Hecho | `tests/economy_test.tscn` en `tools/run_tests` |
| T20 | Corregir desbordamientos de texto en libreta y resumen de apuesta hípica | Codex | Pendiente | Ningún texto se solapa ni deja símbolos en líneas aisladas en las capturas a 1280 × 720 |
| T21 | Venta en directo de apuestas de fútbol: hacer visible el valor de mercado y el beneficio/pérdida en máquina y TV | Codex | Hecho | Un ticket abierto se puede vender desde máquina o TV y muestra importe total y resultado neto según la cuota actual |
| T22 | Mapa en dos zonas: Barra (Lucía, máquina, TV de fútbol, periódico, libreta) y Salón (TV hípica, billar, Chencho) | Codex | Hecho | Un jugador nuevo sabe dónde está cada juego sin preguntar |
| T23 | Botones de la máquina: digitales de los 90 (LCD, plástico), chapuceros pero claros | Codex | Pendiente | Roi da el visto bueno a una captura |
| T24 | Libreta y periódico simplificados: menos reglas, más claros | Claude | Pendiente | Cada página se lee en menos de 10 s |
| T25 | Billar: guía de trayectoria tipo móvil (camino de la blanca y de la bola tocada) | Claude | Hecho | Nv1 se gana en 1-3 intentos; Nv3 sigue costando |
| T26 | Campaña de varias noches: menos objetivo por noche, deuda creciente (sustituye a T16) | Claude | Hecho | Simulada y documentada en `BALANCE.md` |
| T27 | Cerrar las apuestas predecibles que Roi explotó | Claude | Hecho (horarios y cruces cambian cada noche; tope de boleto y cuota) | La estrategia ya no gana sola |
| T28 | Plan de versión móvil: Godot export vs Flutter (`docs/design/MOBILE.md`) | Claude (revisa Codex) | Pendiente | Roi decide la vía |

## P1 — Pulido

| Id | Tarea | Dueño | Estado |
|---|---|---|---|
| T09 | "Juice": contador de dinero animado que indique origen y signo, destello en goles, sacudida al ganar/perder, hover con sonido | Codex | Pendiente |
| T10 | Feedback de la racha: aviso grande al subir y al romperse | Codex | Pendiente |
| T11 | Resumen de cierre más rico: gráfica de dinero por hora y mejor jugada | Claude (datos) + Codex (UI) | Pendiente |
| T12 | Arte: el arte de Lucía tiene "CONFIANZA" impreso que ya no significa nada; ilustración para la mesa del Chencho y el billar | Roi | Pendiente |
| T13 | Opciones: volumen, pantalla completa, velocidad por defecto | Codex | Pendiente |
| T14 | `machine_screen.gd` reconstruye la lista entera cuando cambia el estado; optimizar si se nota | Codex | Pendiente |
| T15 | Textos: repasar tono cómico y erratas en todas las pantallas | Claude | Pendiente |

## P2 — Si sobra tiempo (requiere visto bueno de Roi)

| Id | Tarea | Estado |
|---|---|---|
| T16 | Semana de noches con deuda creciente → pasa a T26 | Absorbida |
| T17 | Eventos del bar (el Chencho interrumpe, apagón en la tele, redada cómica) | Idea |
| T18 | Traducción al inglés | Idea |

## Errores conocidos

- Sin sonido (T02).
- El equilibrio no se ha probado con jugadores reales (T01, T05).

## Hecho (resumen)

- Noche completa jugable: fútbol, caballos, billar, cartas, tienda, libreta, cierre.
- Billar "Tiro imposible" en lugar del futbolín (T19).
- Personajes con 3 niveles y 14 objetos de habilidad; racha con tope x1,5.
- Minijuegos: arreo, penalti, presión del partido, contar cartas.
- Repo organizado, pruebas automáticas y documentación (09/10).
