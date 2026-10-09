# Handoff — versión final de jam (noche completa)

## Estado

Juego jugable de principio a fin: portada → bar → (máquina, TVs, periódico, contactos, Lucía, futbolín, cartas) → cierre con Tino. Diseño completo en `design/NIGHT_FLOW.md`.

## Cómo probar

- Abrir `game/project.godot` con Godot 4.7 y pulsar F5 (escena principal `scenes/night.tscn`).
- Pruebas: `tests/night_sim_test.tscn` (lógica), `tests/night_capture.tscn` (capturas en `tests/output/n*.png`), `tests/night_soak_test.tscn` (dos noches enteras con apuestas aleatorias). Las tres pasan en Godot 4.7.1.

## Pendiente / ideas si sobra tiempo

- Sonido (ambiente de bar, gol, campana de salida).
- Afinar la dificultad del futbolín con jugadores reales (constantes en `ui/minigames/futbolin.gd`, rivales en `ui/screens/rivals_screen.gd`).
- Exportar a Windows (Proyecto → Exportar) para entregar el ejecutable.
