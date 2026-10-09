# McLarens: La última combinada

Juego de apuestas y minijuegos en un bar de barrio, hecho en **Godot 4.7** con arte pixel 2.5D.
Le debes 500 € a Tino y viene a cobrar a las 02:00. Tienes 100 € y una noche en el McLarens.

![El bar](docs/screenshots/02_bar.jpg)

## Cómo se juega

Una partida es **una noche de 18:00 a 02:00** (~13 minutos reales). El reloj corre solo; todo se hace desde el bar:

| Dónde | Qué | Personaje |
|---|---|---|
| Máquina | Fútbol (19:00 y 22:30, 1X2 en directo con cobro anticipado) y 10 carreras de caballos | El Búho (fútbol), El Cortado (caballos) |
| TV 1 / TV 2 | Ver el partido (medidor de presión, penalti) y la carrera (arrear a tu caballo) | |
| Futbolín del fondo | Minijuego de habilidad a 3 goles | Tino (rival) |
| Mesa del rincón | ¿Mayor o menor? con baraja española | El Chencho (rival) |
| Barra | Tienda: rondas para subir de nivel a la gente y objetos | Lucía |
| Periódico / libreta | Cartelera de la noche / tu gente, objetos y racha | |

Cada personaje tiene **3 niveles**; las mejoras y objetos **no regalan dinero**, dan herramientas que premian jugar bien. Diseño completo: [`docs/design/GDD.md`](docs/design/GDD.md).

## Arrancar

1. Instala [Godot 4.7](https://godotengine.org/download) (versión estándar, no .NET).
2. Abre `game/project.godot` y pulsa **F5**. Escena principal: `res://scenes/night.tscn`.

Controles: ratón; **P** pausa, **ESC** vuelve al bar, **ESPACIO** arrea/chuta en los minijuegos.

## Pruebas

```bash
tools/run_tests.sh          # lógica (headless)
tools/run_tests.sh todas    # + capturas de todas las pantallas, 2 noches completas, futbolín
```
En Windows: `.\tools\run_tests.ps1` o `.\tools\run_tests.ps1 -Todas` (define `$env:GODOT` si Godot no está en el PATH). Las capturas salen en `game/tests/output/`.

## Estructura

```
game/                 Proyecto Godot
  night/              Lógica de la noche (autoload Night, fútbol, caballos, catálogo)
  simulation/         Simulador de partidos por intervalos
  data/               Equipos y hechos de partido
  ui/                 Pantallas, minijuegos, widgets, HUD y kit de UI
  scenes/night.tscn   Escena principal
  tests/              Pruebas automáticas (escenas .tscn)
  assets/             Arte conceptual v1 y fuentes (OFL)
docs/
  design/GDD.md       Diseño vivo del juego
  ARCHITECTURE.md     Mapa del código y cómo extenderlo
  coordination/       Flujo de trabajo, tablero de tareas, decisiones y handoff
  CODEX_ONBOARDING.md Arranque para Codex
  screenshots/        Capturas actuales
  source/ references/ archive/ art/   Material original e histórico
tools/                Scripts de pruebas
```

## Cómo trabajamos

Dos agentes (Claude y Codex) y el autor trabajan sobre este repo por commits pequeños. Reglas en [`docs/coordination/WORKFLOW.md`](docs/coordination/WORKFLOW.md); tareas en [`docs/coordination/TASK_BOARD.md`](docs/coordination/TASK_BOARD.md).

El código del prototipo de julio (slice de investigación con el caso Bruno Salas) está en la rama `archive/slice-julio`.

## Créditos

Fuentes [Jersey 10](https://fonts.google.com/specimen/Jersey+10) y [VT323](https://fonts.google.com/specimen/VT323), licencia SIL OFL 1.1 (`game/assets/fonts/`).
Juego de ficción. Ningún caballo fue sobornado.
