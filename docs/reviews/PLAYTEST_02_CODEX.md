# Playtest 02 — Codex

Versión recorrida: `8653cd2`

Entorno: Godot 4.7.1, Windows, 1280 × 720.

## Alcance y método

Se recorrió la campaña integrada de cinco noches, desde la barra de la noche 1 hasta el cierre victorioso de la noche 5, y se revisaron veinte capturas: barra, máquina, periódico y cierre de cada noche. Para aislar la continuidad y la presentación, el recorrido de diagnóstico inyectó antes de cada cierre el dinero necesario para pagar a Tino y conservar 200 €. Por tanto, valida transiciones, persistencia visual, carteleras y textos, pero **no valida la dificultad económica ni sustituye el playtest humano de Roi**.

Las pruebas completas ya estaban en verde sobre esta integración: `NIGHT_SIM_OK`, `ECONOMY_TEST_OK`, `NIGHT_SOAK_OK`, `NIGHT_CAPTURE_OK` y `BILLAR_TEST_OK`.

## Resultado por noche

| Noche | Cuota | Lo que funciona | Problemas observados |
|---|---:|---|---|
| 1 | 100 € | HUD marca `CUBIERTO`; periódico explica hoy y mañana; partidos, caballos y horas son legibles. | La máquina no muestra de forma visible el tope de 50 €; la presión solo aparece explicada en un pie de texto. |
| 2 | 150 € | Cambian partidos, cuotas y favoritos; la campaña conserva la banca prevista. | Al empezar a las 18:00 siguen visibles cuatro avisos de la noche 1, incluidos resultado de carrera y renovación de Lucía. |
| 3 | 300 € | HUD cambia correctamente a `faltan 100`; la nueva cuota se refleja en periódico y cierre. | Persisten los avisos viejos; el cierre usa `LLEGASTE CON` para el dinero inicial y obliga a deducir qué ocurrió. |
| 4 | 500 € | Cartelera distinta y texto `Mañana cobrará 750 €`. | Se repiten los avisos heredados; la pantalla final sigue sin separar inicio, cierre, cobro y remanente. |
| 5 | 750 € | El periódico anuncia que es la última; el cierre cambia a `¡HAS SALDADO LA DEUDA!` y `EMPEZAR DE NUEVO`. | El resumen económico mantiene las etiquetas ambiguas. |

## Hallazgos priorizados

### P1 — Corregir antes del playtest de Roi

1. **Los avisos no se limpian al cambiar de noche.** Desde la noche 2, la barra arranca a las 18:00 mostrando eventos de la noche anterior: cierre de apuestas, salida y resultado de la carrera 10, y renovación de Lucía. Además de ocupar espacio, presentan como actuales hechos caducados. Se registra como X05, en el área de presentación de Codex.
2. **El cierre mezcla cuatro momentos económicos.** `LLEGASTE CON` muestra el dinero con el que comenzó la noche, mientras `TE QUEDAN` muestra el saldo posterior al cobro. La operación es correcta, pero las etiquetas no lo explican. Ya está repartido: Claude aporta los datos en C04 y Codex los monta en X02; no se crea una tarea duplicada.

### P2 — Resolver en H1

1. **La presión aún no se aprende en el sitio donde se usa.** El pie de la máquina dice que el Búho enseña quién aprieta, pero en la vista previa no hay un indicador que conecte esa frase con una decisión. X03 ya cubre frase, icono y presencia en máquina/TV.
2. **El tope de 50 € no se ve en la máquina.** Sí aparece en el periódico, pero no junto al control de la apuesta. T23 ya lo cubre junto con la revisión visual de botones.
3. **Los controles `−/+` de la máquina parecen menores que el objetivo táctil de 48 px.** No bloquea Windows; debe medirse y corregirse en T30 antes de Android.
4. **La portada sigue concentrando demasiadas reglas.** El periódico ya demuestra una jerarquía mucho mejor. C05 y T04 trasladarán la explicación al momento de uso.
5. **Quedan problemas ya registrados en capturas anteriores:** el `€` aislado del resumen hípico (T20), la claridad de niveles de Lucía (X04) y el arte secundario antiguo (T12).

### P3 — Pulido

- Godot avisa de anclas opuestas no iguales cuyo tamaño se sobrescribe tras `_ready()` en `night_main.gd:33`. No produjo un defecto visible a 1280 × 720, pero conviene revisarlo cuando se haga la pasada adaptable/móvil.
- El cierre repite casi la misma composición cinco veces. Funciona para H0; T11 puede darle variedad con datos de rendimiento cuando la campaña ya esté validada.

## Lectura por pantalla

- **Barra:** la división en dos zonas se entiende y la máquina está junto a la TV de fútbol, como pidió Roi. El pie inferior resume bien qué contiene cada zona. El único bloqueo de integración son los avisos caducados.
- **Periódico:** es la pantalla más clara del recorrido. Explica ubicación (`tele de la barra` / `tele del salón`), cuota actual, siguiente cuota y límite de boletos sin exceso de texto. Las carteleras cambian las cinco noches.
- **Máquina:** partidos y cuotas varían; la repetición deportiva señalada en la review anterior parece resuelta. Faltan el tope visible y una explicación gráfica de la presión.
- **Cierre:** las transiciones y el desenlace final funcionan, pero la contabilidad necesita las etiquetas de C04/X02.

## Conclusión de H0

La campaña puede atravesar las cinco noches y presenta cuotas, agenda y final correctos. C01–C04 entraron después de tomar estas capturas; antes de entregar una versión a Roi falta integrar sus textos en X02 y limpiar los avisos entre noches en X05. La dificultad real, la capacidad de llegar a cada cuota y la calibración de los minijuegos quedan deliberadamente fuera de este recorrido visual y deben comprobarse con simulación y juego humano.
