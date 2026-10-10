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

## Organización del proyecto (usuario, 09/10 22:50)

- **D-064 — Repositorio:** el proyecto vive en GitHub `Roitxelo/maclarens`; `F:\JUEGOS\MacLarens` es un clon. Se trabaja por commits pequeños (ver `WORKFLOW.md`).
- **D-065 — Código del slice retirado:** `main_bar`, `betting`, `core/game_state`, `contracts`, `odds`, `round_setup`, `info_board` y sus pruebas salen del árbol; quedan en la rama `archive/slice-julio`.
- **D-066 — Trabajo a dos agentes:** Claude (reglas, equilibrio, pruebas, docs) y Codex (sensación de los minijuegos, UI, audio, export) con reparto por áreas en `WORKFLOW.md` y tareas en `TASK_BOARD.md`.

## Billar (usuario, 09/10 23:24)

- **D-067 — Billar en lugar de futbolín:** el minijuego contra Tino pasa a ser billar en modo "Tiro imposible": series de 3 mesas preparadas con una misión cada una (tronera marcada, a banda, carambola, sin tocar la negra); aciertas 2 de 3 y ganas la apuesta. Mismos niveles de Tino (20/40/60 €, Nv3 perdona 100 € la primera vez). Lo implementa Claude (T19) aunque `ui/minigames/` sea área de Codex.

## Equilibrio (Claude, 10/10)

- **D-068 — Billar con cuotas:** Tino paga 1:1, 2:1 y 3:1 según su nivel y el jugador elige la apuesta (10 € hasta 50/100/150 €). Sustituye a las apuestas fijas de 20/40/60 €.
- **D-069 — Ventajas calibradas con simulación:** caballo en forma +3–5 de nota (antes +14–22, rompía la economía con las Gafas); momento del fútbol más persistente. Datos en `docs/design/BALANCE.md`.
- **D-070 — Más margen para la habilidad (Roi, 10/10):** se mantiene la deuda de 500 €, la banca inicial sube de 100 € a 200 €, el arreo perfecto gana fuerza, Chencho Nv3 deja de barajar entre manos y el segundo partido tiene rachas de presión más marcadas. Se validará de nuevo con simulación y playtest.
- **D-071 — Venta de posiciones de fútbol (Roi, 10/10):** todo ticket abierto puede venderse durante el directo por su valor de mercado (`apuesta × cuota capturada ÷ cuota actual`), mostrando importe total y beneficio o pérdida. Búho Nv2 elimina la comisión del 10 %.
- **D-073 — Campaña de 5 noches (Roi, 10/10):** sustituye a la noche única de 500 €. Cuotas 100/150/300/500/750 €, 200 € iniciales; se conservan dinero, niveles y objetos. Cada noche cambia horarios y emparejamientos (Roi explotaba que todas las noches eran iguales). Datos en `BALANCE.md`.
- **D-074 — Límites de la máquina:** boleto máximo 50 € y cuota hípica máxima 15,0. Sin ellos, el soplo (Gafas) + arreos a un tapado a 40 → +2.000 € en una carrera y la campaña se decidía en la noche 2.
- **D-075 — Billar con guía y tope:** guía de trayectoria real cuya longitud baja con el nivel de Tino; Tino paga 1:1 / 3:2 / 2:1 con apuesta máxima 30 / 60 / 100 € y juega 3 series por noche. El perdón de 100 € es una vez por campaña.
- **D-076 — El perdón de Tino va a la última noche (C02):** los 100 € se descuentan de la quinta cuota (750 → 650 €), no de la de hoy. Antes podía cubrir entera la cuota de la noche 1 (100 €).
- **D-077 — Textos como datos:** los textos que dependen de reglas (cierre, "esta noche" del periódico) salen de `game/data/game_texts.gd` (Claude); las pantallas solo los muestran (Codex). Las cuotas se leen con `Night.quota(k)`, que aplica las rebajas.
- **D-078 — Guía del billar corta de base (C06, review 03):** sin objetos, la guía llega hasta el primer choque de la blanca y enseña 60 px de la salida de la bola tocada. La Tiza suma un rebote y 200 px. La corazonada Pulso firme enseña el tiro entero. El nivel de Tino ya no cambia la guía: la dificultad la ponen las mesas.
- **D-080 — La barra de Lucía cuesta más y tiene límites (C08, review 04):** Roi lo maxeó todo en una campaña. Rondas 45/100 € (Búho y Cortado) y 35/80 € (Chencho); objetos un 25 % más caros; **una ronda por personaje y noche** (el Nv3 llega como pronto la noche 2); **dos objetos por noche**; cambiar el surtido cuesta 10 €.
- **D-079 — Abandonar una mano de cartas (T07):** ESC o el botón de salida piden confirmación. Abandonar pierde el bote, registra la apuesta ya pagada como derrota y libera la pausa del minijuego al volver al bar.
- **D-072 — Bar en dos zonas (Roi, 10/10):** la barra reúne máquina, TV de fútbol, Lucía, periódico y libreta; el salón del fondo reúne TV hípica, billar y cartas. Una navegación visible conecta ambos espacios para reducir el caos del mapa único.
