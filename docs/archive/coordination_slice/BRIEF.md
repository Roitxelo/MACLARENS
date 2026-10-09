# Brief oficial de preproducción

## Juego

**McLarens: La última combinada** es un roguelite estratégico de información y riesgo ambientado en un bar nocturno. El jugador busca una ventaja informativa antes de que la casa la incorpore a sus cuotas: observa varios partidos, contrasta fuentes imperfectas, apuesta y reacciona en directo.

La apuesta es el vehículo. El juego trata de incertidumbre, lectura de señales, presión temporal y gestión del riesgo.

## Formato confirmado

- Motor: **Godot**.
- Presentación: **2.5D**, con espacio físico del bar y elementos 2D integrados en profundidad.
- Referencia visual y de composición: *Do Not Feed the Monkeys* (imágenes de `references/`), sin copiar su interfaz literalmente.
- La máquina de apuestas, periódico, red de contactos y personajes aparecen como objetos o zonas visibles del escenario; el jugador elige cuál atender.
- Dinero, tiempo y suerte forman el HUD permanente.

## Fantasía

Ser la persona más despierta del bar: conectar un rumor, una estadística y un movimiento de cuota antes que la casa. La satisfacción principal es pensar **«lo vi antes»**, aunque una buena lectura todavía pueda perder por varianza.

## Consenso inicial Claude–Codex

- Un solo escenario y fútbol como único deporte para la jam.
- Dos partidos visibles simultáneamente.
- Información incompleta y al menos dos fuentes contradictorias.
- Simulación por intervalos y cuotas dinámicas.
- Una apuesta sencilla y una acción en directo: cobro anticipado.
- Interfaz diegética y tono ficticio, nocturno y absurdo.
- Primero debe probarse una ronda jugable de 3–5 minutos.
- Tenis, boxeo, megacasino, metaprogresión y sistemas extensos quedan fuera.

## Desacuerdos reales y resolución

- **Tamaño inicial:** Codex propuso una run de 8–12 minutos con combinada y borracho; Claude una sola ronda de 3–5 minutos. Se adopta una secuencia reversible: primero la ronda mínima; solo si funciona se amplía al MVP de jam.
- **Módulo de Claude:** Codex propuso investigación e información; Claude propuso simulación y cuotas. Se asigna a Claude el módulo completo de simulación futbolística y cuotas, que es su propuesta y un núcleo relevante. Codex conserva arquitectura, integración, UI, apuestas y flujo.
- **Borracho, información y cierre:** el usuario ha fijado que el borracho aparezca mínimamente, que Telegram se sustituya por un periódico consultable más una red de contactos inmediata, y que el primer prototipo pueda ser abierto aunque la run futura exija alcanzar una cantidad antes del cierre.

## Resultado esperado de la jam

Una experiencia corta donde el jugador pueda detectar una contradicción, decidir bajo presión, apostar, observar dos partidos, ver moverse una cuota, cobrar o mantener y comprender por qué ganó o perdió.

La cadena informativa inicial será: **noticia persistente del periódico → aviso urgente de un contacto → relación o contradicción detectable → cuota todavía sin actualizar → apostar o investigar más**.
