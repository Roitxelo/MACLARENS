# Análisis de Claude — qué ha pasado y cómo trabajar (10/10, 06:10)

> Roi nos ha pedido a Claude y a Codex, a la vez, analizar el lío y proponer un trabajo especializado. Esta es la parte de Claude. Codex, escribe la tuya en `ANALISIS_CODEX.md` y luego unimos las dos en un `WORKFLOW.md` v2 que apruebe Roi.

## 1. Qué ha pasado (hechos)

1. **Hay dos copias del repo en el PC de Roi:**
   - `C:\Users\roice\Desktop\MacLarens`: al día (`b3b6c17`). Es donde trabaja Codex.
   - `F:\JUEGOS\MacLarens`: **7 commits por detrás** (se quedó en `d462d42`, 03:31) porque tiene `CLAUDE.md` modificado y Git no puede actualizar.

   Los documentos dicen que la buena es la de F:. **Si Roi juega desde F:, está probando una versión antigua**: sin campaña, sin guía del billar, sin las dos zonas.
2. **La coordinación está repartida en 8 archivos:** `TASK_BOARD`, `HANDOFF`, `CLAUDEHANDOFF`, `CODEXHANDOFF`, `REVIEW_02_ROI`, `DECISIONS`, `CODEX_PLAYTEST_01` y `WORKFLOW`. El estado de una misma tarea aparece en varios sitios y se contradice. Por ejemplo, `REVIEW_02` sigue diciendo "T22 pendiente del visto bueno" cuando ya está hecha.
3. **Choque de números:** los dos creamos tareas a la vez y las dos acabaron como T21. Hubo que renumerar (tres commits solo de documentos).
4. **Las áreas se han pisado en los dos sentidos:**
   - Codex tocó economía y simulación (`64bbe7f`: `night_state`, `horse_races`, `match_simulator`, `balance_sim`).
   - Claude tocó pantallas de Codex (`hud`, `machine_screen`, `title_screen`).

   La regla de "un arreglo de una línea en área ajena" se ha estirado.
5. **Mensajes simultáneos → trabajo duplicado:** el mismo mensaje de Roi a los dos produjo dos repartos de la review 02 (Claude `959bf67` y Codex `1b18bb7`).
6. **Mucho cambio sin jugar:** desde el último playtest de Roi han entrado campaña, topes de la máquina, billar nuevo, mapa nuevo, libreta y periódico. Todo sale de simulaciones, no de jugar.
7. **Buzones desordenados:** las normas dicen "mensajes nuevos arriba", pero unos se añadieron arriba y otros abajo.
8. **Todos los commits salen como `Roitxelo`.** Solo la línea `Co-Authored-By` dice quién lo hizo.

**Lo que sí funciona:** `main` siempre jugable con 5 pruebas automáticas en verde, commits pequeños y con prefijo, y decisiones numeradas.

## 2. Propuesta: trabajo especializado

### Roles (sin excepciones)

| Rol | Quién | Qué decide | Archivos |
|---|---|---|---|
| Dirección | **Roi** | Visión, prioridades; juega cada hito y aprueba | Reviews, decisiones |
| Sistemas | **Claude** | Reglas, economía, números, simulación, datos, pruebas, herramientas, documentación de diseño, minijuego del billar (física + pantalla) | `game/night/`, `game/simulation/`, `game/data/`, `game/tests/`, `tools/`, `docs/design/`, `ui/minigames/billar.gd`, `billar_lobby_screen.gd` |
| Presentación | **Codex** | Pantallas, controles (ratón y táctil), *feel*, audio, arte, export Windows/Android | `game/ui/` (salvo el billar), `game/assets/`, `project.godot`, export |

- Si necesitas algo en el área del otro, **lo pides en su buzón**. Nada de "una línea".
- La única excepción son los textos que Roi ve. Los redacta Claude y los pega el dueño de la pantalla, o Claude los deja en `catalog.gd` y la pantalla los lee de ahí.

### Una fuente de verdad por cosa

| Qué | Dónde (solo ahí) |
|---|---|
| Estado de las tareas | `docs/coordination/TASK_BOARD.md` |
| Mensajes entre agentes | `CLAUDEHANDOFF.md` (Codex → Claude) y `CODEXHANDOFF.md` (Claude → Codex). **Nuevo arriba**, 10 líneas como máximo; lo resuelto se borra |
| Lo que dice Roi | `docs/reviews/REVIEW_NN.md`, que se escribe una vez y no lleva estados |
| Decisiones | `DECISIONS.md` |
| Cómo trabajamos | `WORKFLOW.md` v2 |

Se archivan en `docs/archive/` estos tres: `HANDOFF.md` (el antiguo), `REVIEW_02_ROI.md` (pasa a `docs/reviews/`) y `CODEX_PLAYTEST_01.md` (pasa a `docs/reviews/`).

### Números de tarea sin choques

- Roi y las reviews: `T01`–`T99`.
- Claude crea `C01`, `C02`…; Codex crea `X01`, `X02`…

### Ritmo por hitos

1. Roi hace una review → cada agente coge **solo sus tareas** del tablero, sin repartir de nuevo.
2. Cuando las tareas del hito están hechas, se pone una etiqueta de versión (`hito-NN`) o una línea en el tablero: "H1 listo para jugar en `<commit>`".
3. **Roi juega ese commit en la carpeta única** → la siguiente review. **No se añaden novedades hasta esa review**; solo arreglos.
4. Cuando Roi escribe a los dos a la vez, cada uno responde solo por su área. El reparto ya está hecho por roles.

### Una sola carpeta en el PC

**Decidido por Roi (06:12): la buena es `F:\JUEGOS\MacLarens`.** Ya está limpia y al día. Roi juega desde ahí. La del escritorio solo debe usarse si Codex trabaja en ella: en ese caso, `git pull` antes de empezar y `git push` al acabar.

## 3. Hito 1 (H1) propuesto: "la campaña jugable"

- **Claude:** ya ha hecho la campaña, la guía del billar, la libreta y el periódico, y `MOBILE.md`. Falta revisar los textos (T15) y los botones táctiles del billar.
- **Codex:** botones de la máquina (T23); que la tienda diga qué desbloquea cada ronda (`Catalog.CHARACTERS[*].short`); explicar la presión (una frase y un icono); T20 y T07.
- **Roi:** juega una campaña completa → `REVIEW_03`.

Después, H2 = móvil (T29–T31) y H3 = audio y *juice*.
