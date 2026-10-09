# Decisiones

## Confirmadas por las fuentes y la síntesis

- **D-001 — Núcleo:** investigar, contrastar, apostar y reaccionar en directo.
- **D-002 — Primer deporte:** fútbol.
- **D-003 — Simultaneidad mínima:** dos partidos visibles.
- **D-004 — Acción en vivo inicial:** cobro anticipado; mantener es la alternativa.
- **D-005 — Primera validación:** una ronda jugable de 3–5 minutos antes de construir una run completa.
- **D-006 — Arquitectura:** separar estado real, conocimiento del jugador y estimación de la casa.
- **D-007 — Claude:** propietario inicial del módulo completo de simulación y cuotas.
- **D-008 — Codex:** propietario inicial de arquitectura, integración, centro de control, apuestas y flujo.
- **D-009 — Ownership:** un solo propietario por archivo durante cada tarea.
- **D-010 — Contenido inicial:** dos fuentes contradictorias sobre un hecho concreto.

## Decisiones reversibles adoptadas

- **D-011:** simulación discreta con cuatro familias iniciales de evento: gol, tarjeta, lesión y córner.
- **D-012:** apuesta simple en el primer prototipo; combinadas solo después de validar el núcleo.
- **D-013:** ticker visible para comunicar cambios de cuota sin implementar aprendizaje real de la casa.
- **D-014:** interfaz funcional y esquemática antes de arte final.
- **D-015:** el primer ciclo termina por criterio jugable, no por completar una lista de sistemas.

## Decisiones del usuario resueltas

- **D-016 — Borracho:** aparecerá de forma mínima como uno de los personajes recurrentes; su intervención sistémica no es obligatoria en el primer prototipo.
- **D-017 — Información persistente:** Telegram se sustituye por un periódico accesible cuando el jugador quiera.
- **D-018 — Información inmediata:** una red de contactos complementa al periódico con personajes recurrentes, un posible grupo tipster, personalidades y tasas de acierto distintas.
- **D-019 — Relaciones:** el jugador podrá descubrir conexiones entre piezas dispersas; para la jam se usarán elementos destacados y relaciones seleccionables, no búsqueda libre.
- **D-020 — Cierre del prototipo:** puede ser una demo abierta sin última combinada.
- **D-021 — Presión de la run:** la intención del juego completo es alcanzar una cantidad de dinero antes del cierre por una deuda u obligación narrativa.

## Decisión creativa resuelta

- **D-030 — Tono de cierre:** la presión económica procede de un prestamista o matón de barrio exagerado y cómico; nunca se presenta como amenaza realista ni mafia seria.

## Decisiones técnicas sustituidas

- **D-022 y D-023:** la maqueta web y su proveedor simulado fueron eliminados al confirmarse Godot como motor. No forman parte del proyecto actual.

## Decisiones de formato confirmadas por el usuario

- **D-024 — Motor:** el juego se desarrollará en Godot.
- **D-025 — Presentación:** el escenario y la interacción serán 2.5D.
- **D-026 — Dirección visual:** gráficos y composición inspirados en las referencias de *Do Not Feed the Monkeys*, sin copia literal.
- **D-027 — Interacción diegética:** máquina, periódico, contactos y personajes aparecen en el escenario y el jugador elige qué atender.
- **D-028 — HUD:** dinero, tiempo y suerte permanecen visibles como recursos principales.
- **D-029 — Limpieza:** la maqueta web y la caché generada de Godot se eliminan; `game/` conserva únicamente fuentes necesarias del proyecto Godot.
- **D-031 — Orden de producción:** se pausa la ampliación mecánica. Primero se fija el lenguaje visual mediante escenario estático, personajes, máquina y vistas de interfaz; después se reconstruye la escena Godot sobre esos assets.
- **D-032 — Master visual v1:** `game/assets/concept/mclarens_bar_master_v1.png` fija encuadre, paleta, capas 2.5D y zonas interactivas provisionales.
- **D-033 — Dirección visual aprobada:** se conserva el estilo completo del kit v1 —paleta, encuadre, personajes, máquina, periódico y representación detallada de los partidos en TV— asumiendo conscientemente su mayor coste artístico.
- **D-034 — Contraste activo:** el periódico aparece limpio en reposo. Los círculos y conexiones solo se muestran después de que el jugador seleccione un nombre y pague el coste temporal de relacionar información.
- **D-035 — Corte del prototipo técnico:** el usuario aprueba la dirección visual, pero rechaza la ejecución jugable asociada. Simulación, cuotas, apuestas, hotspots, HUD funcional y flujo Bruno actuales no se consideran diseño validado ni base de producción; solo se conservan como código experimental hasta su sustitución.
- **D-036 — Nuevo orden:** antes de reimplementar sistemas se construirá un prototipo de interacción de una única secuencia completa, usando los visuales aprobados y sin simulación automática de fondo.
- **D-037 — Regla de arranque:** el partido permanece detenido hasta que el jugador realiza su primera apuesta informada. El saque inicial funciona como consecuencia y feedback de esa decisión.
- **D-038 — Tiempo:** relacionar noticias cuesta 2 minutos; usar una corazonada cuesta 1 minuto; cada intervalo de 3 minutos de partido consume 1 minuto del tiempo restante hasta el cierre.
- **D-039 — Dinero y posición:** la run empieza con 100 €, el importe inicial puede ajustarse entre 5 y 50 € en pasos de 5, y solo se permite una posición activa por partido en este slice.
- **D-040 — Cobro anticipado:** el valor depende de importe, cuota capturada, cuota actual y un margen visible de la casa; cerrar la posición devuelve dinero inmediatamente y el partido continúa.
- **D-041 — Suerte:** empieza con 3 cargas. Una carga ofrece una corazonada cualitativa y cuesta también 1 minuto; aporta interpretación, nunca revela el resultado ni altera retroactivamente el partido.
- **D-042 — Resolución:** al minuto 90 una victoria local paga importe × cuota capturada; empate o derrota pierde el importe. No se abren nuevas posiciones tras cobrar dentro del mismo partido.
- **D-043 — Integración visual funcional:** las dos TVs deben mostrar datos dentro de sus pantallas físicas; los controles de la máquina usan hotspots sobre el arte aprobado y solo el importe dinámico se redibuja. El HUD se oculta en el close-up de la máquina para no tapar su interfaz.
- **D-044 — Una sola verdad de mercado:** TVs, selección de la máquina, ticket, cuota capturada, cashout y resolución consumen el mismo `OddsSnapshot`. Los dos partidos visibles son seleccionables y una apuesta activa bloquea el cambio de mercado.
- **D-045 — Contactos diegéticos:** la libreta de la mesa abre tres fuentes recurrentes; consultar una cuesta 1 minuto y su fiabilidad orienta sin garantizar la verdad.
- **D-046 — Personajes como sistema:** hablar con Lucía ofrece acciones con costes y consecuencias distintas; información, confianza y gasto no son equivalentes.
- **D-047 — Causalidad del mercado:** durante una apuesta activa se muestran cuota capturada, cuota actual, cashout, último evento y causa de la variación en una sola pantalla.
- **D-048 — Estructura de run:** el cierre diario compara banca con una deuda de 500 €, muestra beneficio del día y permite avanzar conservando dinero; el prototipo parte de 5 días.

## Giro final de jam (usuario, 09/10)

- **D-049 — Run de una noche:** la run pasa a ser una sola noche en el McLarens (18:00–02:00). Se empieza con 100 € y Tino cobra 500 € al cierre. Sustituye a D-048 (5 días).
- **D-050 — Varias actividades apostables:** dentro del bar se apuesta a fútbol (2 partidos, 19:00 y 22:30, 1X2 en vivo con cobro), caballos (10 carreras, una cada 45 min), futbolín contra parroquianos y "¿Mayor o menor?" con El Chencho (el borracho).
- **D-051 — Habilidad y azar autorizados:** el usuario autoriza añadir minijuegos de habilidad (futbolín) y de azar con decisión de cobrar/seguir (cartas) junto a las apuestas informadas. Cambio de pilar aprobado explícitamente.
- **D-052 — Reloj continuo:** el tiempo corre solo (0,6 min/s, x1/x2/x4 y pausa). Llamadas, charlas y minijuegos consumen bloques de minutos; lo programado sucede igual mientras tanto.
- **D-053 — Información:** periódico con partes médicos, favoritos y rumores de cuadra; contactos con fiabilidad distinta (3 llamadas cada uno). Corazonadas (3) dan información verdadera.
- **D-054 — Escena principal:** `scenes/night.tscn`. El slice anterior (`scenes/main_bar.tscn`) se conserva intacto. Copia de seguridad del `project.godot` anterior: `game/project.godot.bak_slice`.

## Versión 2 de la noche (usuario, 09/10 21:48)

- **D-055 — Fuera rumores:** se retiran lesiones ocultas, rumores, periódico informativo y contactos con fiabilidad. El periódico pasa a cartelera y la libreta muestra gente, objetos y racha. `night/info_board.gd` queda sin uso.
- **D-056 — Un personaje por juego con 3 niveles:** Búho (fútbol, ayuda), Cortado (caballos, ayuda), Chencho (cartas, rival que juega peor cuanto más bebe) suben con rondas en la barra; Tino (futbolín, rival) sube cuando le ganas y en Nv3 rebaja 100 € la deuda.
- **D-057 — Tienda de Lucía:** rondas, 3 objetos rotativos (máx. 5 en inventario, 15 en el catálogo) y chupito de suerte.
- **D-058 — Racha:** multiplicador del beneficio por victorias seguidas (+0,15) y por variedad de juegos (+0,25 por juego distinto). Solo apuestas de 10 € o más.
- **D-059 — Corazonadas por juego:** gol de tu equipo, caballo +12, Tino distraído, ver la carta.

## Versión 3: mejoras de habilidad (usuario, 09/10 22:19)

- **D-060 — Sin recompensas exageradas:** fuera multiplicadores de pago (bufanda, boleto, abuela, copa, posavasos, hucha, llavero) y primas por gol. La racha queda en +0,1 por victoria con tope x1,5.
- **D-061 — Mejoras = herramientas de habilidad:** Búho da el medidor de presión (momento del partido que la casa no incluye en la cuota) y en Nv3 un penalti de puntería; Cortado da arreos de timing en carreras simuladas en directo; Chencho borracho (Nv3) paga con probabilidades de baraja entera, así que contar cartas da ventaja; objetos del futbolín cambian el control (portero, mango, tiza).
- **D-062 — Corazonadas de ejecución:** cámara lenta, arreo perfecto, engañar al portero y ver la carta. Ya no hay gol garantizado ni empujón fijo.
- **D-063 — Calibración:** caballos con retorno ~91 % apostando a todo; dos noches de apuestas aleatorias acaban en 181 € y 2 €.
