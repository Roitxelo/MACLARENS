# Arquitectura

Todo el juego vive en `game/` (Godot 4.7, GDScript, renderer `gl_compatibility`, 1280×720 con `canvas_items`).
La UI se construye **por código** (no hay escenas por pantalla): cada pantalla es un `Control` creado desde un script.

## Mapa

```
scenes/night.tscn ── ui/night_main.gd      Raíz: capa de pantallas + HUD + avisos (toasts) + fundido
                         │  go("pantalla", args)
                         ├── ui/hud.gd                     Dinero, hora, suerte, racha, deuda, agenda, pausa/velocidad
                         └── ui/screens/*.gd, ui/minigames/*.gd
night/night_state.gd  (autoload "Night")   Estado de la run y reglas
  ├── night/football_market.gd   2 partidos sobre MatchSimulator + cuotas 1X2 (Poisson)
  ├── night/horse_races.gd       10 carreras simuladas en directo + arreos
  └── night/catalog.gd           Datos: personajes, niveles, objetos, racha
simulation/match_simulator.gd    Partido por intervalos de 3 min (gol, tarjeta, lesión, córner, momento)
simulation/billiard_sim.gd       Física de billar determinista + comprobación de misiones
data/billiard_layouts.gd         Mesas del "Tiro imposible" (3 por nivel) con solución guardada
data/game_texts.gd               Textos que dependen de reglas (cierre, "esta noche"): GameTexts.end_summary(), tonight_lines()
data/teams/team_stats.gd         8 equipos ficticios
data/match_facts/match_fact.gd   Hecho oculto de partido (hoy sin uso en la noche, lo usa el simulador)
ui/ui_kit.gd (class UIKit)       Paleta, fuentes, botones, hotspots, paneles, retratos
ui/widgets/pitch_tv.gd           Retransmisión de fútbol (compacta en el bar, grande en TV 1)
ui/widgets/race_track.gd         Pista de caballos (compacta en el salón, grande en TV hípica)
```

### Pantallas (`ui/night_main.gd → SCREENS`)

| Clave | Script | Qué es |
|---|---|---|
| `title` | screens/title_screen.gd | Portada |
| `bar` | screens/bar_screen.gd | Zona de barra: fútbol, máquina, Lucía, periódico y libreta |
| `salon` | screens/salon_screen.gd | Salón del fondo: TV hípica, billar y cartas |
| `machine` | screens/machine_screen.gd | Máquina: pestañas Fútbol / Caballos / Mis tickets |
| `match_tv` | screens/match_tv_screen.gd | TV 1: partido, crónica, presión, cobro, penalti |
| `race_tv` | screens/race_screen.gd | TV 2: carrera y minijuego de arreo |
| `paper` | screens/paper_screen.gd | Cartelera (Diario Gol Local) |
| `notebook` | screens/notebook_screen.gd | Libreta: niveles, objetos, racha |
| `shop` | screens/shop_screen.gd | Barra de Lucía: rondas, objetos, chupito |
| `billar_lobby` | screens/billar_lobby_screen.gd | Reto de billar a Tino |
| `billar` | minigames/billar.gd | Billar "Tiro imposible" |
| `cards` | minigames/mayor_menor.gd | Mayor o menor con el Chencho |
| `end` | screens/end_screen.gd | Cierre con Tino |

`minigames/penalty_overlay.gd` es un overlay que abre `match_tv`.

**Contrato de pantalla:** script que extiende `Control` con `var main` y `var args` (los rellena `night_main.go()` antes de `_ready`). Si define `refresh()`, se llama en cada `Night.changed` (≈ cada minuto de reloj y en cada cambio de dinero). Navegar: `main.go("clave", {...})`.

## Tiempo y estado (`Night`)

- `clock` en minutos desde las 18:00 (float). Avanza en `_process` a `MINUTES_PER_SECOND * speed` salvo pausa (`pauses` con motivos: `user`, `minigame`).
- Cada minuto entero: `football.on_minute`, `races.on_minute`, liquidación de tickets, reposición de la tienda, fin de noche (02:00 o sin dinero ni tickets abiertos).
- `advance(n)` salta n minutos de golpe (minijuegos, partidas de cartas); todo lo programado sucede igual.
- Las carreras se integran en pasos de 0,05 min (`races.update(clock)`), así el resultado no depende de los FPS.
- Señales: `changed`, `toast(text, kind)`, `night_over(reason)`.

### Dinero

- `spend` / `earn` para movimientos directos.
- **Toda victoria de juego** debe pasar por `register_win(game, stake, gross)` (aplica la racha) y toda derrota por `register_loss(game)`. `game` ∈ `football`, `horse`, `billar`, `cards`.
- Tickets: `place_football`, `place_horse(race, horse, stake, kind)`, `cashout(bet)`. Se liquidan solos en `_settle_bets`.

### Personajes y objetos

- Niveles en `Night.levels` (1–3). `Night.level("buho")`, `buy_round(who)`.
- Objetos: `Night.trinkets` (ids), `has_trinket(id)`. Los efectos se consultan **donde ocurren** (p. ej. `billar.gd` mira `tiza`, `taco`, `guante`, `repeticion`).

## Cómo añadir cosas

- **Un objeto:** entrada en `Catalog.TRINKETS` (id, nombre, precio, juego, texto) + `if Night.has_trinket("id")` en el punto del juego que modifica. Aparece solo en la tienda y en la libreta. Que premie habilidad o dé información, no dinero directo (ver D-060/D-061).
- **Un nivel/personaje:** `Catalog.CHARACTERS` + constantes por nivel; la tienda lista rondas para quien tenga `rounds`.
- **Una pantalla:** script en `ui/screens/`, entrada en `SCREENS` y hotspot/botón que haga `main.go`.
- **Una prueba:** escena en `game/tests/` con un `Node` y script que imprima una marca `ALGO_OK` y haga `get_tree().quit()`; añádela a `tools/run_tests.*`.

### Billar

- Una mesa nueva: añádela a `BilliardLayouts.LEVELS` (bola 0 = blanca, 1 = objetivo) con su misión y reglas, y ejecuta el buscador: `godot --headless --path game -s res://../tools/dev/billar_solver.gd -- 0.25`. Guarda en `solution` un ángulo/potencia que funcione; `billar_test` lo verifica.
- Si cambias la física (`billiard_sim.gd`: fricción, troneras, rebotes), vuelve a pasar el buscador: las soluciones guardadas pueden dejar de valer.

## Pruebas existentes

| Escena | Comprueba |
|---|---|
| `tests/night_sim_test.tscn` | Lógica headless: tres noches, compras, arreo, liquidación |
| `tests/campaign_test.tscn` | Campaña: cuotas, pago a Tino, qué se conserva entre noches, variedad de partidos, rebaja en la última noche, textos del cierre |
| `tests/economy_test.tscn` | Pagos, cobro con/sin comisión, racha (tope x1,5), calcetín, herradura, colocado, seguro del Chencho, perdón de Tino una sola vez |
| `tests/night_soak_test.tscn` | Dos noches completas alternando todas las pantallas con apuestas aleatorias |
| `tests/night_capture.tscn` | Recorre todas las pantallas y guarda capturas en `tests/output/` |
| `tests/billar_test.tscn` | Las 9 mesas se resuelven con su solución guardada; una serie en autoplay gana con tiros exactos y pierde con tiros desviados |

Las de render necesitan ventana (en Linux sin pantalla, `xvfb-run`).

## Convenciones de código

- GDScript con tipos (`var x := ...`, `-> void`). Tabuladores.
- Comentarios y textos en español. Nombres de código en inglés salvo términos del juego (`billar`, `chencho`...).
- Constantes de equilibrio arriba de cada script o en `catalog.gd`; nada de números mágicos repartidos.
- Coordenadas de UI en píxeles de la ventana 1280×720 (el arte v1 es 1672×941 escalado ×0,7656).
