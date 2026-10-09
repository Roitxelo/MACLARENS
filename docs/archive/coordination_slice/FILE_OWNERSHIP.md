# File ownership

El proyecto es Godot y vive bajo `game/`. No deben añadirse prototipos paralelos en otra tecnología.

## Reservas del primer ciclo

| Área / ruta prevista | Responsable | Puede editar | Criterio de finalización |
|---|---|---|---|
| `game/core/` | Codex | Solo Codex | Reloj y flujo de ronda ejecutan un ciclo completo |
| `game/ui/` | Codex | Solo Codex | Escena 2.5D, focos interactivos y HUD de dinero, tiempo y suerte son operables y legibles |
| `game/betting/` | Codex | Solo Codex | Crear apuesta, mantener y cobrar actualizan el estado económico |
| `game/integration/` | Codex | Solo Codex | UI y apuestas consumen el módulo de Claude sin duplicar su lógica |
| `game/contracts/` | Codex en C1 | Solo Codex durante C1 | Contratos de entrada/salida mínimos, documentados en el propio código y estables para C2 |
| `game/simulation/` | Claude | Solo Claude | Dos partidos avanzan por intervalos y emiten eventos reproducibles |
| `game/odds/` | Claude | Solo Claude | Las cuotas responden coherentemente al estado y eventos |
| `game/data/teams/` | Claude | Solo Claude | Cuatro equipos mínimos alimentan la simulación sin lógica embebida |
| `game/data/match_facts/` | Claude | Solo Claude | Existe el hecho oculto de la primera contradicción y puede consultarse por contrato |
| `game/information/` | Claude en F11 | Solo Claude durante F11 | Tres fuentes exponen personalidad, coste, sesgo, fiabilidad y respuesta reproducible mediante una API aislada y probada |

## Archivos compartidos de coordinación

| Archivo | Responsable actual | Regla |
|---|---|---|
| `coordination/TASK_BOARD.md` | Codex | Actualiza estados; no sustituye resultados reales |
| `coordination/DECISIONS.md` | Codex | Registra decisiones breves; cambios de visión requieren usuario |
| `coordination/FILE_OWNERSHIP.md` | Codex | Se actualiza antes de abrir tareas que solapen rutas |
| `coordination/HANDOFF.md` | Codex | Mantiene el siguiente paso accionable |
| `design/CORE_LOOP.md` | Codex | Cambios de pilares requieren usuario; el caso Bruno Salas queda como referencia oficial |
| `design/GAME_JAM_SCOPE.md` | Codex | El alcance solo crece tras una prueba jugable |
| `design/MVP.md` | Codex | Refleja criterios de éxito acordados; el scope solo crece tras prueba jugable |
| `design/IDEA_BACKLOG.md` | Codex | Recibe ideas pospuestas; no autoriza implementación |

## Regla de colisión

Ningún modelo edita una ruta reservada al otro durante una tarea activa. Si un cambio cruza límites, el propietario hace el cambio o se transfiere explícitamente la propiedad antes de editar.
