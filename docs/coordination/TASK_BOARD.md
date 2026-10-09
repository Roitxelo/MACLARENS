# Tablero de tareas

Estados: `Pendiente` · `En curso (dueño)` · `Hecho` · `Bloqueado (motivo)`.
Antes de empezar una tarea, ponla `En curso` en tu primer commit. Al terminar, `Hecho` + commit.
Dueño propuesto según `WORKFLOW.md`; se puede cambiar avisando aquí.

## P0 — Para entregar (jugable, presentable, sin sustos)

| Id | Tarea | Dueño | Estado | Hecho cuando |
|---|---|---|---|---|
| T01 | Probar jugando y calibrar los minijuegos: velocidad de la aguja del arreo (`race_screen.gd`), mirilla del penalti (`penalty_overlay.gd: SPEED`), IA del futbolín por nivel (`Catalog.TINO_SKILL`, `futbolin.gd`) | Codex | Pendiente | Un jugador nuevo gana a Tino Nv1 en 2-3 intentos, Nv3 cuesta; el arreo perfecto sale ~1 de cada 3 intentando; el penalti pegado al palo se consigue con práctica |
| T02 | Audio básico: ambiente de bar, gol, silbato, salida de caballos, cartas, monedas, golpes del futbolín, clic de botones. Bus de música/efectos | Codex | Pendiente | Cada acción importante suena; volumen ajustable en código |
| T03 | Export a Windows (preset + `.exe` en `builds/`, fuera del repo) | Codex | Pendiente | El `.exe` arranca en un PC sin Godot |
| T04 | Primera noche guiada: mensajes contextuales la primera vez que se entra en cada sitio (qué hacer, controles) | Codex (UI) + Claude (textos) | Pendiente | Un jugador nuevo entiende máquina, arreo, penalti, cartas y tienda sin leer el GDD |
| T05 | Equilibrio de la deuda: bot "jugador hábil" que simula noches (arreos buenos, contar cartas, presión) y mide si 500 € es alcanzable; ajustar `START_DEBT`/precios | Claude | Pendiente | Informe en `docs/design/BALANCE.md`: jugador al azar < 15 % de éxito, hábil 50-70 % |
| T06 | Avisos (toasts) que tapan contenido en carrera, lobby del futbolín y bar: moverlos o dar zona propia por pantalla | Codex | Pendiente | Ninguna captura de `night_capture` tiene texto tapado |
| T07 | Poder rendirse/salir del futbolín y de una mano de cartas (ESC con confirmación) | Codex | Pendiente | Salir no deja el reloj en pausa ni el dinero inconsistente |
| T08 | Prueba de regresión de economía: test que verifica pagos, cobro, racha (tope x1,5), herradura, seguro del Chencho y perdón de Tino | Claude | Pendiente | `tests/economy_test.tscn` en `tools/run_tests` |

## P1 — Pulido

| Id | Tarea | Dueño | Estado |
|---|---|---|---|
| T09 | "Juice": contador de dinero animado, destello en goles, sacudida al ganar/perder, hover con sonido | Codex | Pendiente |
| T10 | Feedback de la racha: aviso grande al subir y al romperse | Codex | Pendiente |
| T11 | Resumen de cierre más rico: gráfica de dinero por hora y mejor jugada | Claude (datos) + Codex (UI) | Pendiente |
| T12 | Arte: el arte de Lucía tiene "CONFIANZA" impreso que ya no significa nada; ilustración para la mesa del Chencho y el futbolín | Roi | Pendiente |
| T13 | Opciones: volumen, pantalla completa, velocidad por defecto | Codex | Pendiente |
| T14 | `machine_screen.gd` reconstruye la lista entera cuando cambia el estado; optimizar si se nota | Codex | Pendiente |
| T15 | Textos: repasar tono cómico y erratas en todas las pantallas | Claude | Pendiente |

## P2 — Si sobra tiempo (requiere visto bueno de Roi)

| Id | Tarea | Estado |
|---|---|---|
| T16 | Semana de noches con deuda creciente y progresión entre noches | Idea |
| T17 | Eventos del bar (el Chencho interrumpe, apagón en la tele, redada cómica) | Idea |
| T18 | Traducción al inglés | Idea |

## Errores conocidos

- Los avisos de la izquierda tapan parte de algunas pantallas (T06).
- El futbolín no se puede abandonar a mitad (T07).
- Sin sonido (T02).
- El equilibrio no se ha probado con jugadores reales (T01, T05).

## Hecho (resumen)

- Noche completa jugable: fútbol, caballos, futbolín, cartas, tienda, libreta, cierre.
- Personajes con 3 niveles y 14 objetos de habilidad; racha con tope x1,5.
- Minijuegos: arreo, penalti, presión del partido, contar cartas.
- Repo organizado, pruebas automáticas y documentación (09/10).
