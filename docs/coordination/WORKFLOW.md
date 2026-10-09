# Flujo de trabajo

Trabajan sobre el repo **Roitxelo/maclarens**: el autor (Roi), **Claude** (en la nube, empuja a GitHub) y **Codex** (en el PC de Roi, en `F:\JUEGOS\MacLarens`). El objetivo es terminar pronto y bien pulido: commits pequeños, siempre jugable.

## Reglas de oro

1. **`main` siempre arranca y pasa las pruebas rápidas.** Nada se sube a `main` si `tools/run_tests` falla.
2. **Antes de empezar:** `git pull --rebase`. **Antes de subir:** `git pull --rebase` otra vez y pruebas.
3. **Una tarea = una línea en `TASK_BOARD.md` con dueño.** Márcala `En curso (Claude|Codex)` en el mismo primer commit de la tarea. No toques archivos que otra tarea en curso tiene reservados.
4. **Commits pequeños y con sentido** (una cosa por commit). Si el cambio es grande, rama + PR.
5. **Las decisiones de diseño se apuntan** en `DECISIONS.md` (D-0xx, una línea) en el mismo commit que las implementa.
6. **Al acabar una tarea:** actualiza `TASK_BOARD.md` y, si cambia el estado general, `HANDOFF.md`.
7. **Cambios de visión** (pilares, tono, estructura de la run) los decide Roi. Proponer sí; imponer no.

## Ramas

- `main`: estable. Commits directos permitidos para cambios pequeños y probados.
- `claude/<tema>` y `codex/<tema>`: trabajo de más de un commit o que toca mucho. Se fusiona con PR (o fast-forward si nadie más ha tocado esos archivos).
- `archive/slice-julio`: histórico, no se toca.

## Mensajes de commit

Español, imperativo, con prefijo:

| Prefijo | Para |
|---|---|
| `feat:` | jugabilidad o pantalla nueva |
| `fix:` | error |
| `balance:` | números de equilibrio |
| `ui:` | maquetación, legibilidad, feedback visual |
| `audio:` | sonido y música |
| `art:` | recursos gráficos |
| `refactor:` | código sin cambio de comportamiento |
| `test:` | pruebas |
| `docs:` | documentación |
| `chore:` | configuración, scripts, export |

Primera línea ≤ 72 caracteres; cuerpo con el porqué si no es obvio. Ejemplo: `balance: aguja del arreo un 15 % más lenta`.

Los commits de agentes terminan con su línea de coautoría (`Co-Authored-By: ...`).

## Definición de terminado

- Funciona jugando (no solo en la prueba).
- `tools/run_tests` (rápidas) en verde; si tocaste UI, también `todas` y has mirado las capturas de `game/tests/output/`.
- Sin `SCRIPT ERROR` en la salida de Godot.
- Documentación al día: GDD si cambia una regla, ARCHITECTURE si cambia la estructura, TASK_BOARD siempre.

## Reparto por defecto

Para evitar choques, cada uno es dueño de un área. Se puede pedir cambio de dueño en `TASK_BOARD.md`.

| Área | Dueño | Por qué |
|---|---|---|
| `game/night/`, `game/simulation/`, `game/data/` (reglas, equilibrio, simulaciones) | Claude | Puede correr miles de noches simuladas para calibrar |
| `game/tests/`, `tools/`, `docs/` | Claude | |
| `game/ui/minigames/` (sensación de control, juice) | Codex | Puede jugar en local con ratón y ventana |
| `game/ui/screens/`, `game/ui/widgets/`, `game/ui/hud.gd` | Codex | Pulido visual jugando |
| Audio, export a Windows, `project.godot` | Codex | Requiere el editor en el PC |
| Arte nuevo | Roi (con ayuda) | |

Un agente puede tocar un área ajena para un arreglo de una línea si lo explica en el commit.

## Sincronización con la carpeta local

- `F:\JUEGOS\MacLarens` es un clon del repo (remoto `origin` = GitHub). Codex trabaja ahí y empuja con las credenciales de Roi.
- Claude trabaja en su clon de la nube y empuja a GitHub. Para traer sus cambios a la carpeta: `git pull`.
- `game/.godot/`, `game/tests/output/` y `.sync/` no se suben (ver `.gitignore`).

## Pruebas

```bash
tools/run_tests.sh            # rápidas
tools/run_tests.sh todas      # completas (ventana o xvfb-run)
```
```powershell
.\tools\run_tests.ps1
.\tools\run_tests.ps1 -Todas
```
