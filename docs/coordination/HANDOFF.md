# Handoff — estado a 09/10/2026, 23:30

## Qué hay

Juego jugable de principio a fin en Godot 4.7: portada → bar → máquina (fútbol y caballos), TVs (partido con presión y penalti; carrera con arreo), futbolín contra Tino, Mayor o menor con el Chencho, barra de Lucía (tienda), periódico (cartelera), libreta → cierre con Tino a las 02:00.

- Diseño: `docs/design/GDD.md`.
- Código: `docs/ARCHITECTURE.md`.
- Cómo trabajar: `docs/coordination/WORKFLOW.md`.
- Tareas: `docs/coordination/TASK_BOARD.md`.

## Pruebas

`tools/run_tests.sh todas` en verde en Godot 4.7.1 (Linux, xvfb): `NIGHT_SIM_OK`, `NIGHT_SOAK_OK`, `NIGHT_CAPTURE_OK`, `FUTBOLIN_TEST_DONE`.

## Lo más urgente

1. **T01** — jugar y calibrar los minijuegos (nadie los ha probado con ratón todavía).
2. **T02** — sonido.
3. **T05** — comprobar que 500 € de deuda es alcanzable jugando bien y no jugando al azar.
4. **T03** — export a Windows.

## Avisos

- La rama `archive/slice-julio` guarda el prototipo anterior (rumores, caso Bruno Salas). No se usa.
- `MatchFact` sigue existiendo porque el simulador lo admite, pero la noche no crea hechos ocultos.
