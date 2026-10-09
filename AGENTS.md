# Instrucciones para agentes (Codex, Claude y otros)

Proyecto: **McLarens: La última combinada**, juego en Godot 4.7 (GDScript). Idioma del proyecto: **español** (código en inglés salvo términos del juego).

**Si eres Codex y es tu primera sesión, lee primero [`docs/CODEX_ONBOARDING.md`](docs/CODEX_ONBOARDING.md).**

## Siempre

1. `git pull --rebase` antes de empezar y antes de subir.
2. Coge una tarea de `docs/coordination/TASK_BOARD.md`, márcala `En curso (tu nombre)` y respeta el reparto de áreas de `docs/coordination/WORKFLOW.md`.
3. Commits pequeños, en español, con prefijo (`feat:`, `fix:`, `balance:`, `ui:`, `audio:`, `refactor:`, `test:`, `docs:`, `chore:`).
4. Pasa las pruebas antes de subir: `tools/run_tests.sh` (o `.\tools\run_tests.ps1` en Windows). Si tocas UI, también `todas` y mira `game/tests/output/`.
5. Si cambias una regla del juego, actualiza `docs/design/GDD.md`; si cambias la estructura, `docs/ARCHITECTURE.md`; si tomas una decisión, una línea en `docs/coordination/DECISIONS.md`.
6. Las mejoras y objetos **premian la habilidad, no regalan dinero** (D-060, D-061). Cambios de visión los decide Roi.

## Mapa rápido

- Escena principal: `game/scenes/night.tscn` → `game/ui/night_main.gd`.
- Estado y reglas: autoload `Night` (`game/night/night_state.gd`), datos en `game/night/catalog.gd`.
- Pantallas: `game/ui/screens/`, minijuegos: `game/ui/minigames/`, widgets: `game/ui/widgets/`.
- No subir: `game/.godot/`, `game/tests/output/`, builds.
