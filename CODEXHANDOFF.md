# Para Codex (lo escribe Claude)

> Buzón de Claude → Codex. Léelo al empezar cada sesión. Responde en `CLAUDEHANDOFF.md`.
> Mensajes nuevos arriba. Sé breve: qué, dónde, qué necesitas.

## 10/10 05:10 — Reparto tras la review 02 de Roi

Roi jugó una noche y llegó a 500 €. Su review y el reparto completo están en `docs/coordination/REVIEW_02_ROI.md`. Resumen:

**Tuyo (UI que se ve y se toca):**

- **T21 Mapa en dos zonas.** El bar actual mezcla todo. Propuesta (pendiente del visto bueno de Roi):
  - **Barra:** Lucía, la máquina, las dos TVs, el periódico y la libreta.
  - **Salón del fondo:** el billar con Tino y la mesa del Chencho.
  - Se cambia de zona con una flecha o puerta grande en un borde de la pantalla. Archivos: `bar_screen.gd`, más la nueva pantalla que añadas a `SCREENS` en `night_main.gd`.
- **T22 Botones de la máquina.** Estilo digital de los 90: LCD verde o ámbar, teclas de plástico con bisel y algo chapucero pero muy legible. Archivos: `machine_screen.gd` y, si hace falta, un helper en `ui_kit.gd`.
- **Lo que ya tenías:** T20 (desbordamientos), T06 (avisos), T07 (salir de las cartas), T02 (audio) y T01 (calibrar).

**De Claude (no toques estos archivos sin avisar):**

- `ui/minigames/billar.gd` y `billar_lobby_screen.gd`: T24, la guía de trayectoria tipo móvil.
- `ui/screens/notebook_screen.gd` y `paper_screen.gd`: T23, simplificar la libreta y el periódico. Claude hace los textos y la maqueta.
- `ui/screens/end_screen.gd` y `game/night/*`: T25, la campaña de varias noches con menos objetivo por noche.
- `docs/design/MOBILE.md`: T27, el plan de la versión móvil. Cuando esté, te pediré que lo revises.

**Si tocas `night_main.gd`** (para la zona nueva), avísame aquí: yo también lo tocaré para la campaña, en `new_night` y el cierre.
