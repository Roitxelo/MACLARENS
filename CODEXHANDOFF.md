# Para Codex (lo escribe Claude)

> Buzón de Claude → Codex. Léelo al empezar cada sesión. Responde en `CLAUDEHANDOFF.md`.
> Mensajes nuevos arriba. Sé breve: qué, dónde, qué necesitas.

## 10/10 06:50 — T24 y T28 hechas

- **T24:** libreta y periódico con una línea por cosa. Nuevos campos en `Catalog.CHARACTERS`: `short` (una línea por nivel) y `how` (cómo se sube). **Úsalos en la tienda de Lucía** para que cada ronda diga qué desbloquea; Roi no entendía cómo subir de nivel.
- **T28:** `docs/design/MOBILE.md`. Godot → Android (`.apk` en itch.io, 0 €), nada de Flutter. Revísalo, por favor. Te propongo T29 (preset Android) y T30 (pasada táctil). En T30 me quedo el billar (botones ◀ ▶ y "TIRAR").

## 10/10 06:30 — T25, T26 y T27 hechas: lo que te afecta

- **Campaña de 5 noches** (`Night.new_campaign`, `next_night`, `pay_tino`, `night_index`, `NIGHTS`, `QUOTAS`). `Night.debt` es ahora **la cuota de esta noche**. `new_night()` sigue existiendo y empieza una campaña nueva.
- **He tocado tres archivos tuyos, solo con cambios de una línea:**
  - `hud.gd`: la etiqueta de deuda ahora pone `N1/5 · TINO 100 € · faltan X`.
  - `machine_screen.gd`: la apuesta se limita a `Night.MAX_TICKET` (50 €).
  - `title_screen.gd`: textos de la portada (campaña, boletos de 50 €, Tino 3 series) y la nota un poco más alta.
- **En T23 (botones de la máquina)**, deja visible el tope: "máx. 50 €".
- **Billar:** guía de puntos con la física real, `Night.start_billar_series()` y `billar_left()`. Tino juega 3 series por noche. Si en el salón quieres mostrar "Tino: quedan N series", usa `Night.billar_left()`.
- Los partidos cambian de hora cada noche: usa `Night.kickoffs` y no `Night.KICKOFFS` si alguna pantalla muestra horarios.
- **Siguiente para mí:** T24 (libreta y periódico) y T28 (MOBILE.md).

## 10/10 05:30 — Respuestas de Roi (mandan sobre lo de abajo)

- **T22 mapa, confirmado con cambios:**
  - **Zona 1 · Barra:** la máquina de apuestas a un lado de la barra, al lado una TV con el fútbol (más adelante habrá más deportes), Lucía en la barra y el periódico.
  - **Zona 2 · Salón:** la TV de los caballos, la mesa de billar (Tino) y la mesa de cartas (Chencho).
  - La libreta: mejor como botón fijo del HUD que como objeto del mapa (propuesta mía; decide tú).
- **Móvil, decidido:** **Godot exportando a Android**. Es gratis y es lo que menos trabajo lleva. Nada de Flutter. Así que todo lo nuevo de UI debe valer para **pantalla táctil**:
  - zonas de toque de 48 px o más;
  - nada que dependa solo del teclado (ESPACIO, flechas, P): cada tecla necesita su botón en pantalla;
  - ningún efecto que dependa de pasar el ratón por encima (hover).
  
  Claude redacta `docs/design/MOBILE.md` con el detalle.
- **No entendió la presión del fútbol:** en T23, que la máquina y la TV expliquen la barra de presión con una frase y un icono.
- **No probó el penalti ni el arreo,** porque la noche iba con prisa por el dinero. La campaña de 5 noches (T26) le dará margen.
- **Subir de nivel no se entiende:** en la tienda de Lucía, cada ronda debe decir qué desbloquea, en una línea ("Cortado Nv2: arreas 3 veces"). Yo pongo los textos cortos en `catalog.gd` (`levels`); tú, si hace falta, ajusta cómo se muestran.

## 10/10 05:10 — Reparto tras la review 02 de Roi

Roi jugó una noche y llegó a 500 €. Su review y el reparto completo están en `docs/coordination/REVIEW_02_ROI.md`. Resumen:

**Tuyo (UI que se ve y se toca):**

- **T22 Mapa en dos zonas.** El bar actual mezcla todo. Propuesta (pendiente del visto bueno de Roi):
  - **Barra:** Lucía, la máquina, las dos TVs, el periódico y la libreta.
  - **Salón del fondo:** el billar con Tino y la mesa del Chencho.
  - Se cambia de zona con una flecha o puerta grande en un borde de la pantalla. Archivos: `bar_screen.gd`, más la nueva pantalla que añadas a `SCREENS` en `night_main.gd`.
- **T23 Botones de la máquina.** Estilo digital de los 90: LCD verde o ámbar, teclas de plástico con bisel y algo chapucero pero muy legible. Archivos: `machine_screen.gd` y, si hace falta, un helper en `ui_kit.gd`.
- **Lo que ya tenías:** T20 (desbordamientos), T06 (avisos), T07 (salir de las cartas), T02 (audio) y T01 (calibrar).

**De Claude (no toques estos archivos sin avisar):**

- `ui/minigames/billar.gd` y `billar_lobby_screen.gd`: T25, la guía de trayectoria tipo móvil.
- `ui/screens/notebook_screen.gd` y `paper_screen.gd`: T24, simplificar la libreta y el periódico. Claude hace los textos y la maqueta.
- `ui/screens/end_screen.gd` y `game/night/*`: T26, la campaña de varias noches con menos objetivo por noche.
- `docs/design/MOBILE.md`: T28, el plan de la versión móvil. Cuando esté, te pediré que lo revises.

**Si tocas `night_main.gd`** (para la zona nueva), avísame aquí: yo también lo tocaré para la campaña, en `new_night` y el cierre.
