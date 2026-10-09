# Playtest 01 — Codex

Versión jugada: `5d1557962d8d83592f686b845b60e2b528d89ed8`  
Versión contrastada con pruebas y capturas tras T19: `1d1b33900364b5af07c9793b5f84882964d856c3`

Entorno: Godot 4.7.1, Windows, 1280 × 720. Se recorrió una noche completa hasta las 02:00 a x1/x4 y se revisaron las capturas de `night_capture`. Durante el playtest Claude sustituyó el futbolín por el billar; no se modificó ni se evaluó manualmente el código reservado de T19.

## Bloqueantes (impiden jugar o entender)

1. **Una mano de cartas atrapa al jugador hasta resolverla.** Tras acertar, `LEVANTARSE` queda deshabilitado y el reloj permanece pausado. Intenté volver al bar y continuar la noche, pero las demás interacciones no podían ocurrir hasta cobrar o perder. Es T07 y necesita confirmación al salir, con devolución o resolución explícita de la apuesta.
2. **Los avisos tapan información accionable.** En carrera cubren participantes y eventos; en la TV de fútbol pisan el campo y el medidor; en el antiguo minijuego/lobby ocupaban controles y resultado. El problema no es solo estético: un aviso sobre un resultado anterior oculta la decisión que toca tomar ahora. T06 debe darles una zona distinta según la pantalla.
3. **El bar no comunica qué es interactivo sin mover el ratón por ensayo y error.** Las zonas son diegéticas y bonitas, pero la primera visita carece de una llamada visual o recorrido mínimo. El texto inferior dice que se pase el ratón, aunque no enseña prioridades ni explica qué conviene hacer antes de la primera carrera.

## Sensación de los minijuegos (arreo, penalti, billar, cartas)

- **Arreo:** el objetivo verde se entiende una vez visible, pero el feedback compite con avisos de carrera. `Fallo: el caballo se asusta` informa del resultado, no de si se pulsó pronto o tarde; falta feedback direccional para aprender el timing. Un único intento no basta para calibrar T01.
- **Penalti:** la instrucción de disparar con clic o espacio es clara. En el primer intento no queda claro qué formas representan mirilla, portero y zona segura ni hacia dónde se mueve cada una; una leyenda de una línea o un primer intento guiado reduciría el azar percibido.
- **Billar:** T19 entró después de la noche jugada. La captura nueva y `BILLAR_TEST_OK` confirman integración y estados de prueba, pero la dificultad por nivel debe calibrarse jugando como parte de T01.
- **Cartas:** probabilidades, bote y botones se leen bien. El historial `HAN SALIDO` es demasiado críptico (`C`, etc.) para un jugador que todavía está aprendiendo la baraja, y el botón deshabilitado para salir no explica por qué. La ausencia de salida con confirmación es el bloqueo principal.

## Legibilidad y UI (qué se tapa, qué no se entiende)

- La portada intenta explicar máquina, cuatro personajes, racha, suerte, reloj y controles antes de la primera acción. Sirve como manual, no como bienvenida: la misión y el botón compiten con ocho líneas de reglas. Conviene conservar misión + reloj y trasladar el resto a T04, cuando cada sistema aparece.
- La libreta solapa texto en la ficha del Búho: la descripción actual salta de línea fuera de su alto y choca con la siguiente mejora. Las filas de personajes necesitan altura dinámica o texto más corto.
- En la máquina de caballos, una devolución grande parte el símbolo `€` en una línea aislada. El estado de apuesta necesita más ancho o una composición separada para selección, cuota y retorno.
- Los toasts usan color por tipo, pero todos tienen la misma jerarquía y duran lo mismo. Un gol, una compra y el aviso de una carrera próxima parecen igual de urgentes.
- El dinero cambia de forma instantánea y el jugador debe deducir la causa leyendo un toast. Falta asociar visualmente el cambio al botón, ticket o resultado que lo produjo (T09).
- El HUD superior funciona bien como referencia permanente. La deuda y la agenda son claras, pero a x4 los avisos desaparecen antes de poder leerlos y no existe historial accesible de eventos recientes.
- La pantalla final es la más clara del flujo: hora, banca, deuda, resultado, mejores momentos y dos acciones inequívocas. Es una buena referencia de jerarquía para el resto.

## Ritmo (¿13 min es mucho/poco?, ¿hay tiempos muertos?)

- A x1, los primeros minutos son lentos si todavía no se han descubierto los hotspots. Falta una primera acción recomendada antes de la carrera de las 18:20.
- x4 elimina los tiempos muertos, pero vuelve ilegibles los toasts y facilita perder una salida o un cierre de apuestas. La velocidad debería reducirse temporalmente ante decisiones urgentes o mantener el aviso hasta que el jugador lo descarte.
- Las cartas pausan correctamente la presión temporal, pero el bloqueo de salida rompe el ritmo de la noche completa.
- Diez carreras más dos partidos producen suficiente actividad; el problema es priorizarla, no añadir más eventos.

## Economía percibida (¿llegaste a 500 €?, ¿qué estrategia funcionó?)

No llegué a 500 €. La noche empezó con 100 €, probé una ronda del Cortado, una apuesta hípica y una mano de cartas. La interfaz explica cuotas y deuda, pero no comunica cuánto debería crecer la banca por tramo horario ni si la run va razonablemente encaminada. El cierre sí explica bien el déficit. T05 debe decidir los números; desde UX conviene dar contexto sin prometer dinero gratis: por ejemplo, marcar el efecto de la primera victoria a Tino sobre la deuda y mostrar siempre el beneficio neto al resolver una apuesta.

## Notas de Roi

No se recibieron notas adicionales de Roi en esta conversación antes de cerrar el informe. La sección queda identificada para incorporarlas sin mezclarlas con observaciones propias. Los hallazgos de este playtest ya se convierten en T04, T06, T07, T09 y T20 en el tablero.

## Propuesta de las 5 siguientes tareas para ti

1. **T06 — Reubicar y priorizar avisos por pantalla.** Es el arreglo UX más inmediato y medible con `night_capture`.
2. **T07 — Salida segura de cartas.** ESC o `LEVANTARSE` con confirmación, estado de apuesta explícito y pausa siempre liberada.
3. **T20 — Corregir desbordamientos de texto.** Libreta y resumen de apuesta hípica primero; revisar todas las capturas a 1280 × 720.
4. **T04 — Primera noche guiada y hotspots legibles.** Enseñar una acción cada vez en lugar de cargar la portada.
5. **T09 — Feedback de transacciones.** Dinero animado con origen, signo y concepto; después destellos y sacudidas.
