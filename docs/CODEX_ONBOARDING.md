# Codex: arranque en McLarens

Hola, Codex. Este documento es tu punto de partida. Léelo entero (10 minutos) antes de tocar nada. Después, trabajaremos en paralelo Claude y tú para terminar el juego pronto y bien pulido.

---

## 1. Qué es el juego (30 segundos)

**McLarens: La última combinada.** Debes 500 € a Tino, un prestamista de barrio cómico. Viene a cobrar a las 02:00. Tienes 100 € y una noche en el bar McLarens para conseguirlos.

- Una partida = **una noche de 18:00 a 02:00**, unos 13 minutos reales. El reloj corre solo (P pausa, x1/x2/x4).
- Todo se hace desde el bar (arte pixel 2.5D, focos interactivos, sin menús abstractos):
  - **Máquina:** fútbol (2 partidos, 1X2 en directo con cobro anticipado) y 10 carreras de caballos.
  - **TV 1 / TV 2:** ver el partido (medidor de presión, penalti) y la carrera (arrear a tu caballo).
  - **Futbolín** contra Tino, **Mayor o menor** contra el Chencho (el borracho).
  - **Barra de Lucía:** tienda de rondas (subir de nivel a la gente) y objetos.
  - **Periódico** (cartelera) y **libreta** (niveles, objetos, racha).
- Cada juego tiene un **personaje con 3 niveles**: Búho (fútbol), Cortado (caballos), Chencho (cartas), Tino (futbolín).
- **Filosofía de diseño (no negociable sin Roi):** las mejoras y objetos **no regalan dinero**. Dan herramientas que premian la habilidad: leer el partido, arrear a tiempo, contar cartas, dominar el futbolín. Apostar a ciegas pierde a la larga.

Detalle completo en `docs/design/GDD.md`. Capturas en `docs/screenshots/`.

## 2. Historia rápida (por qué está así)

1. **Julio:** tú y Claude hicisteis un *slice* de investigación con periódico, contactos con fiabilidad, el caso Bruno Salas y una sola apuesta. La dirección visual se aprobó; la jugabilidad no convenció. Ese código está en la rama `archive/slice-julio` y sus documentos en `docs/archive/`.
2. **09/10:** Roi pidió acabar el juego con algo más simple y variado. Claude rehízo el flujo como una noche con varios juegos (v1). Luego quitó rumores y lesiones y añadió personajes y objetos (v2). Por último cambió las recompensas exageradas por mejoras de habilidad (v3, la actual).
3. **09/10, noche:** repo en GitHub, reorganizado, con pruebas y esta documentación.

Las decisiones están numeradas en `docs/coordination/DECISIONS.md` (las importantes ahora son D-049 a D-066).

## 3. Primeros pasos (haz esto en tu primera sesión)

1. `git pull` en `F:\JUEGOS\MacLarens` (el repo es `https://github.com/Roitxelo/maclarens`).
2. Lee en este orden: `AGENTS.md` → este documento → `docs/coordination/WORKFLOW.md` → `docs/ARCHITECTURE.md` → `docs/design/GDD.md` → `docs/coordination/TASK_BOARD.md`.
3. Abre `game/project.godot` en Godot 4.7 y **juega una noche entera**. Toma notas de todo lo que se sienta mal: controles, legibilidad, ritmo, textos tapados, dificultad.
4. Ejecuta las pruebas: `.\tools\run_tests.ps1 -Todas` (pon `$env:GODOT` apuntando a `Godot_v4.7.x_win64_console.exe`). Deben salir cuatro OK.
5. Escribe tu diagnóstico en `docs/coordination/CODEX_PLAYTEST_01.md` (qué falla, qué sobra, qué falta, por prioridad) y súbelo en un commit `docs: primer playtest de Codex`. Claude lo leerá para coordinar.
6. Coge tu primera tarea del tablero (recomendado: **T01** calibrar minijuegos, o **T06** avisos que tapan contenido) y empieza.

## 4. Cómo trabajamos los dos

Resumen de `WORKFLOW.md`:

- **`main` siempre jugable.** Pruebas rápidas en verde antes de cada push.
- `git pull --rebase` antes de empezar y antes de subir.
- **Commits pequeños**, en español, con prefijo: `feat:`, `fix:`, `balance:`, `ui:`, `audio:`, `art:`, `refactor:`, `test:`, `docs:`, `chore:`.
- Trabajo de varios commits → rama `codex/<tema>` y PR (o fast-forward si no hay conflicto).
- **Reclama la tarea** en `TASK_BOARD.md` (`En curso (Codex)`) en tu primer commit. Al terminar, márcala `Hecho`.
- **Reparto de áreas para no pisarnos:**

| Tú (Codex) | Claude |
|---|---|
| `game/ui/minigames/` (sensación de control, *juice*) | `game/night/` (reglas, economía, catálogo) |
| `game/ui/screens/`, `game/ui/widgets/`, `game/ui/hud.gd` | `game/simulation/`, `game/data/` |
| Audio, `project.godot`, export a Windows | `game/tests/`, `tools/`, `docs/` |

  Para un arreglo de una línea en un área ajena, adelante; explícalo en el commit. Para algo mayor, apunta la petición en `TASK_BOARD.md` y que lo haga el dueño (o pide el cambio de dueño).
- **Números de equilibrio:** los de los minijuegos (velocidad de agujas, IA) los ajustas tú jugando. Los de la economía (precios, cuotas, deuda) los ajusta Claude con simulaciones; si al jugar ves que algo está roto, apúntalo con datos ("con X objetos gano 300 € en 2 carreras").
- **Decisiones:** si decides algo de diseño, una línea D-0xx en `DECISIONS.md`. Cambios de visión (pilares, tono, estructura de la run) → pregunta a Roi.

## 5. Mapa técnico en un minuto

- Godot 4.7, GDScript con tipos, renderer `gl_compatibility`, 1280×720.
- **La UI se construye por código.** No hay escenas por pantalla: `ui/night_main.gd` tiene un diccionario `SCREENS` y `go("clave", args)` crea la pantalla. Cada pantalla es un `Control` con `var main`, `var args` y, opcionalmente, `refresh()` (se llama con cada `Night.changed`).
- **`Night`** (autoload, `game/night/night_state.gd`) es la única fuente de verdad: reloj, dinero, suerte, niveles, objetos, tickets, racha. Toda victoria pasa por `Night.register_win(game, stake, gross)` y toda derrota por `register_loss(game)`.
- **Datos** en `game/night/catalog.gd` (personajes, niveles, objetos, racha).
- `UIKit` (`game/ui/ui_kit.gd`): paleta, fuentes (Jersey 10 y VT323), botones, hotspots sobre el arte, retratos recortados de `character_lineup_v1.png`.
- Pausar el reloj durante un minijuego: `Night.set_pause("minigame", true/false)`. Consumir tiempo de golpe: `Night.advance(minutos)`.
- Pruebas: escenas en `game/tests/` que imprimen una marca `*_OK`; scripts en `tools/`.

Todo con más detalle en `docs/ARCHITECTURE.md`.

## 6. Dónde podemos darle caña (tu lista)

Prioridad de entrega (del tablero, P0):

1. **T01 — Calibrar minijuegos jugando.** Aguja del arreo (`ui/screens/race_screen.gd`, la aguja cruza la barra en 1,1 s; zona verde en `Night.whip_green_half()`), mirilla del penalti (`ui/minigames/penalty_overlay.gd`, `SPEED`, `keeper_half`), IA del futbolín (`Catalog.TINO_SKILL`, velocidades en `ui/minigames/futbolin.gd`). Criterios en el tablero.
2. **T06 — Avisos que tapan contenido** (caja de toasts a la izquierda en `ui/night_main.gd`).
3. **T07 — Salir del futbolín y de una mano de cartas** sin romper el reloj ni el dinero.
4. **T02 — Audio** (no hay ningún sonido todavía). Usa `AudioStreamPlayer` en un autoload pequeño, por ejemplo `Sfx`, para no repartir reproductores por las pantallas. Sonidos libres (CC0) o generados.
5. **T03 — Export a Windows.**
6. **T04 — Primera noche guiada** (UI tuya; Claude puede escribir los textos).

Después, pulido (P1): *juice* (dinero animado, destellos, sacudidas), feedback de la racha, opciones de volumen y pantalla completa.

Lo que lleva Claude en paralelo: **T05** (simular jugadores hábiles y al azar para fijar la deuda), **T08** (prueba de regresión de la economía), **T15** (repaso de textos) y lo que salga de tu playtest.

## 7. Cosas que conviene saber (para no perder tiempo)

- `game/.godot/` no se sube; si Godot se queja de importaciones, ábrelo una vez en el editor o lanza `godot --headless --import` en `game/`.
- El arte v1 (`game/assets/concept/*.png`, 1672×941) se dibuja escalado ×0,7656 a 1280×720. Las coordenadas de los hotspots están en píxeles de pantalla.
- Varios fondos tienen texto impreso del slice antiguo; por eso algunas pantallas los tapan con paneles (máquina, final). No es un error.
- `Pixelify Sans` se descartó porque Godot la pintaba mal (letras cambiadas). Usa `UIKit.FONT_UI` (Jersey 10) y `UIKit.FONT_SCREEN` (VT323). Ninguna tiene ★ ni flechas: dibújalas.
- Etiquetas con `autowrap`: usa `UIKit.place()` (ya reaplica el tamaño al final del frame) o pon el autowrap antes de dar tamaño.
- En los `_draw()`, los hijos se pintan **encima** del dibujo del padre: los fondos de los minijuegos se dibujan en `_draw`, no con un `ColorRect` hijo.
- El reloj sigue corriendo en máquina, TVs, periódico y tienda (es intencional: presión). Solo se pausa en minijuegos y con P.

## 8. Formato de tu primer informe (`CODEX_PLAYTEST_01.md`)

```markdown
# Playtest 01 — Codex
Versión: <hash del commit>
## Bloqueantes (impiden jugar o entender)
## Sensación de los minijuegos (arreo, penalti, futbolín, cartas)
## Legibilidad y UI (qué se tapa, qué no se entiende)
## Ritmo (¿13 min es mucho/poco?, ¿hay tiempos muertos?)
## Economía percibida (¿llegaste a 500 €?, ¿qué estrategia funcionó?)
## Propuesta de las 5 siguientes tareas para ti
```

¡A por ello! Cualquier duda sobre reglas o datos, déjala en el informe o en `TASK_BOARD.md` y Claude la recoge.
