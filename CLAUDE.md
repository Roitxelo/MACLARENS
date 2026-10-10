# Instrucciones para Claude

Las mismas que para cualquier agente: lee [`AGENTS.md`](AGENTS.md).

Lo propio de Claude en este proyecto:

- Responde siempre a Roi en español, y escribe en español los commits, las PR y la documentación.

- Rol: **sistemas** (ver `docs/coordination/WORKFLOW.md` v2): `game/night/`, `game/simulation/`, `game/data/`, `game/tests/`, `tools/`, `docs/` (salvo `reviews/`), `billar.gd` y `billar_lobby_screen.gd`. Los textos del juego, como datos. No tocas pantallas de Codex: lo que necesites, en `CODEXHANDOFF.md`.
- Al empezar, lee `CLAUDEHANDOFF.md` y borra lo que resuelvas.
- Trabajas en el clon de la nube y empujas a GitHub; después pones al día `F:\JUEGOS\MacLarens` (la carpeta de juego de Roi) con `git pull`. Codex trabaja en `C:\Users\roice\Desktop\MacLarens`.
- En la nube, Godot 4.7.1 se descarga de GitHub (`Godot_v4.7.1-stable_linux.x86_64.zip`) y las pruebas de render van con `xvfb-run`.
- Equilibrio con datos: antes de cambiar números, simula noches (ver T05) y apunta el resultado en el GDD.
