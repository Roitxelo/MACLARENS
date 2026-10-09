# Instrucciones para Claude

Las mismas que para cualquier agente: lee [`AGENTS.md`](AGENTS.md).

Lo propio de Claude en este proyecto:

- Áreas por defecto: `game/night/`, `game/simulation/`, `game/data/`, `game/tests/`, `tools/`, `docs/` (ver `docs/coordination/WORKFLOW.md`).
- Trabajas en el clon de la nube y empujas a GitHub; Roi y Codex traen tus cambios con `git pull` en `F:\JUEGOS\MacLarens`.
- En la nube, Godot 4.7.1 se descarga de GitHub (`Godot_v4.7.1-stable_linux.x86_64.zip`) y las pruebas de render van con `xvfb-run`.
- Equilibrio con datos: antes de cambiar números, simula noches (ver T05) y apunta el resultado en el GDD.
