# Review 02 — Roi (10/10, 05:05)

## Lo que dijo

1. El mapa no se entiende: reestructurar o hacer **dos mapas**.
2. Le gusta cómo se juega. Es algo complicado, pero llegó a 500 € "abusando un poco de las apuestas predecibles".
3. El **billar es muy difícil**, por exceso de precisión. Pide una guía lineal tipo juego de móvil que marque el camino de la bola.
4. La **libreta y el periódico** tienen demasiadas reglas: menos texto, más claro.
5. **Menos objetivo por noche y más noches**, intentando ganar más.
6. **Botones de la máquina**: digitales de la época, algo chapuceros, pero claros y limpios.
7. Hay que **diferenciarse de *Gamble With Your Friends***, manteniendo las reglas actuales. Su idea es sacar también una **versión móvil en Dart/Flutter**.

## Reparto

| Id | Tarea | Dueño | Notas |
|---|---|---|---|
| T21 | Mapa en dos zonas: **Barra** (Lucía, máquina, TVs, periódico, libreta) y **Salón** (billar, Chencho) | Codex | Propuesta pendiente del visto bueno de Roi |
| T22 | Botones de la máquina estilo LCD/plástico de los 90 | Codex | |
| T23 | Libreta y periódico simplificados (textos y maqueta) | Claude | |
| T24 | Billar: guía de trayectoria completa (bola blanca y bola tocada) calculada con la física real | Claude | La dificultad pasa de "precisión al píxel" a "elegir bien el tiro" |
| T25 | Campaña de varias noches con objetivo creciente, sustituye a T16 | Claude | Números con simulación (T05) |
| T26 | Cerrar las apuestas predecibles | Claude | Falta que Roi diga cuáles eran |
| T27 | Plan de versión móvil (`docs/design/MOBILE.md`) | Claude, con revisión de Codex | Ver "Móvil" abajo |

Codex sigue además con T20, T06, T07, T02 y T01.

## Móvil (para decidir)

- **Godot ya exporta a Android e iOS** con el mismo código. El trabajo sería la interfaz táctil (botones grandes, sin teclado ni ESPACIO) y la vertical u horizontal.
- **Flutter** obliga a reescribir el juego entero en Dart (con Flame u otro motor). Son semanas, y habría dos códigos que mantener.
- La plataforma por sí sola no diferencia: *Gamble With Your Friends* también podría salir en móvil. Lo que diferencia es el **contenido**:
  - el bar de barrio español con sus personajes (Tino, el Chencho, Lucía, el Búho, el Cortado);
  - apuestas deportivas reales en directo (fútbol, caballos);
  - minijuegos de **habilidad** en lugar de azar de casino;
  - la deuda como historia a lo largo de varias noches.

Claude redactará `MOBILE.md` con las dos vías, su coste y una recomendación.
