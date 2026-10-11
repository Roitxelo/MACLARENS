# McLarens: La última combinada · versión 1.0 (PC)

Fecha: 11/10/2026. Plataforma: Windows x86_64 (un solo `McLarens.exe`, sin instalar nada).

## Qué es

Juego de apuestas y minijuegos de habilidad en un bar de barrio, en pixel art 2.5D. Le debes 1.800 € a Tino, que te los cobra en **cinco noches** (100, 150, 300, 500 y 750 € a las 02:00). Empiezas con 200 €.

- **La Barra:** la máquina de apuestas (2 partidos de fútbol en directo y 10 carreras por noche, boletos de hasta 50 €), la tele del fútbol (presión y penalti), Lucía (rondas que suben de nivel a tu gente y objetos) y el periódico.
- **El Salón:** la tele de los caballos (arrear a tu caballo), el billar "Tiro imposible" con Tino (guía de trayectoria) y Mayor o menor con el Chencho (cartas vistas a la vista).
- **Cuatro personajes con tres niveles** y 14 objetos de habilidad: las mejoras no regalan dinero, dan herramientas.

## Cómo se genera

```bash
tools/release/build_windows.sh 1.0     # → builds/McLarens_v1.0.zip (desde el último commit)
```

El script exporta desde una copia limpia del último commit con `tools/release/export_presets.cfg`. Además genera una build de Linux con el mismo `.pck` y la arranca 10 s como prueba de humo. El zip lleva `McLarens.exe` y `LEEME.txt`.

## Comprobado

- Las 6 pruebas automáticas en verde: noche, economía, campaña, dos noches completas, capturas de todas las pantallas y billar.
- La build exportada arranca sin errores de script.
- Equilibrio simulado (`docs/design/BALANCE.md`): ninguna estrategia fija gana la campaña. El jugador hábil del bot la gana un 10 % de las veces y las personas, más.

## Conocido

- El `.exe` no está firmado: Windows avisa la primera vez ("Más información" → "Ejecutar de todas formas").
- No hay sonido (T02, pendiente para una versión siguiente).
- La versión móvil (H2) y el acabado (H3) quedan para después de la 1.0.
