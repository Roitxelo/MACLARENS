# Flujo de trabajo (v2, aprobado por Roi el 10/10/2026)

Sale de unir `ANALISIS_CLAUDE.md` y `ANALISIS_CODEX.md` (archivados en `docs/archive/coordinacion_2026-10-10/`). Repo: **Roitxelo/MACLARENS**, rama `main`.

## 1. Roles (sin excepciones)

| Rol | Quién | Decide | Archivos |
|---|---|---|---|
| **Dirección** | Roi | Visión, prioridades, aprueba cada hito jugándolo | `docs/reviews/`, decisiones de visión |
| **Sistemas** | Claude | Reglas, economía, números, simulación, datos y textos del juego, pruebas, herramientas, diseño y el **billar entero** | `game/night/`, `game/simulation/`, `game/data/`, `game/tests/`, `tools/`, `docs/` (salvo `reviews/`), `game/ui/minigames/billar.gd`, `game/ui/screens/billar_lobby_screen.gd` |
| **Presentación** | Codex | Pantallas, controles (ratón y táctil), *feel*, audio, arte, capturas, export a Windows y Android | `game/ui/` (salvo los dos del billar), `game/assets/`, `game/scenes/`, `project.godot`, export |

- Si necesitas un archivo del otro, **lo pides en su buzón** y esperas. No hay "arreglos de una línea".
- **Textos que ve el jugador:** los escribe Claude como datos (`game/night/catalog.gd` o `game/data/texts.gd`) y la pantalla los lee de ahí. Si una pantalla necesita un texto nuevo, Codex lo pide; si Claude cambia un texto, no toca la pantalla.
- **Visión** (pilares, tono, estructura de la run): solo Roi. Proponer sí, imponer no.

## 2. Una fuente de verdad por cosa

| Qué | Dónde (solo ahí) |
|---|---|
| Estado de las tareas | `docs/coordination/TASK_BOARD.md` |
| Mensajes entre agentes | `CLAUDEHANDOFF.md` (Codex → Claude) y `CODEXHANDOFF.md` (Claude → Codex), en la raíz del repo |
| Lo que dice Roi y los playtests | `docs/reviews/` (cada review se escribe una vez y luego no se edita; no lleva estados) |
| Decisiones | `docs/coordination/DECISIONS.md` (D-0xx, una línea) |
| Reglas del juego | `docs/design/GDD.md`; los números, en `docs/design/BALANCE.md` |
| Cómo trabajamos | este archivo |

**Buzones:**
- Lo nuevo va **arriba**, con fecha y hora, en 10 líneas como máximo.
- Quien **lee** un mensaje y lo resuelve, lo borra del buzón.
- Si hace falta registrarlo, va a `DECISIONS.md` o al tablero. El buzón no es un archivo histórico.

## 3. Números de tarea

- `T01`–`T99`: los que salen de una review de Roi o los que ya existían.
- `C01`, `C02`…: tareas nuevas que crea Claude. `X01`, `X02`…: tareas nuevas que crea Codex.
- Así no hay choques aunque escribamos a la vez.

## 4. Hitos

```
review de Roi → cada uno coge SUS tareas del hito → trabaja → "H# listo en <commit>" → Roi juega en F: → siguiente review
```

1. Una review de Roi abre un hito en el tablero. **No se vuelve a repartir.** Cada agente coge las tareas de su rol.
2. Dentro de un hito solo entra lo que está en él. Si surge algo nuevo, va a `Ideas` del tablero.
3. Al cerrar un hito:
   - pruebas `todas` en verde;
   - Claude pone `F:\JUEGOS\MacLarens` al día con `git pull`;
   - el tablero dice `H# listo para jugar en <commit>`.
4. **Hasta que Roi juegue y escriba la review, solo se aceptan arreglos.**
5. Si Roi escribe a los dos a la vez, cada uno responde **solo por su rol**. Si la respuesta toca al otro, va a su buzón; no se hace un reparto nuevo.

## 5. Carpetas

| Carpeta | Quién | Regla |
|---|---|---|
| Clon en la nube (`/home/claude/maclarens`) | Claude | `git pull --rebase` → trabajar → pruebas → `git push` → `git pull` en `F:` |
| `C:\Users\roice\Desktop\MacLarens` | Codex | `git pull --rebase` antes de empezar, `git push` al acabar |
| `F:\JUEGOS\MacLarens` | Roi, para jugar | Nadie la edita a mano; solo `git pull` |

Nunca se trabaja en la carpeta del otro. `game/.godot/`, `game/tests/output/` y `.sync/` no se suben.

## 6. Commits

- **`main` siempre jugable:** las pruebas rápidas en verde antes de cada push.
- Un commit = una cosa. Español, en imperativo, con prefijo: `feat:`, `fix:`, `balance:`, `ui:`, `audio:`, `art:`, `refactor:`, `test:`, `docs:`, `chore:`. La primera línea, de 72 caracteres como máximo.
- Si el trabajo ocupa varios commits y toca mucho, va en una rama `claude/<tema>` o `codex/<tema>`.
- Al final del mensaje, la línea de coautoría del agente (`Co-Authored-By: ...`). Es lo único que distingue a Claude de Codex, porque todos los commits salen como `Roitxelo`.
- La decisión de diseño va en `DECISIONS.md` **en el mismo commit** que la implementa.

## 7. Terminado significa

- Funciona jugando, no solo en la prueba. Si tocaste UI: `tools/run_tests.sh todas` y has mirado las capturas de `game/tests/output/`.
- No hay `SCRIPT ERROR` en la salida de Godot.
- Están al día el GDD (si cambia una regla), `ARCHITECTURE.md` (si cambia la estructura) y el tablero (siempre).
- **El hito lo aprueba Roi jugando**: "Hecho" en el tablero quiere decir "listo para el playtest", no "aprobado".

## 8. Pruebas

```bash
tools/run_tests.sh            # rápidas: night_sim, economy, campaign
tools/run_tests.sh todas      # + soak, capturas, billar (ventana o xvfb-run)
```
```powershell
.\tools\run_tests.ps1
.\tools\run_tests.ps1 -Todas
```
