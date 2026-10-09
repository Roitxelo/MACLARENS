# Core loop

## Fantasía operativa

Observar mejor que la casa, construir una lectura con datos incompletos y actuar antes de que la oportunidad desaparezca.

## Bucle principal

1. **Observar:** ver encuentros, estado y cuotas actuales.
2. **Investigar:** consultar el periódico persistente o recibir información inmediata de la red de contactos.
3. **Contrastar:** detectar apoyo, contradicción, antigüedad o sesgo.
4. **Inferir:** decidir qué escenario parece más probable sin alcanzar certeza.
5. **Actuar:** apostar o dejar pasar antes de que cambie la cuota.
6. **Seguir:** leer eventos simultáneos y nueva información.
7. **Gestionar riesgo:** mantener o cobrar anticipadamente.
8. **Resolver:** separar calidad de lectura, resultado deportivo y resultado económico.
9. **Escalar:** en el juego completo, avanzar hacia mayor presión y la última combinada.

## Primer minuto

- Dos partidos son visibles desde el inicio.
- Una cuota ofrece contexto inmediato.
- Una noticia del periódico y un aviso reciente de un contacto discrepan sobre una lesión.
- Investigar más tiene un coste temporal claro.
- El jugador puede apostar pronto.
- Un cambio de partido o información mueve la cuota.
- Aparece la decisión mantener/cobrar.

## Reglas de diseño

- Consultar más nunca debe ser automáticamente óptimo: la cuota o el tiempo avanzan.
- La información revela o interpreta el mundo; no fuerza por sí misma el resultado.
- Los cambios importantes deben tener una causa perceptible.
- La simultaneidad aporta tensión, no ocultación arbitraria.
- Una buena decisión puede perder, pero el cierre debe reconocer su fundamento.
- El periódico puede consultarse cuando se quiera; la oportunidad caduca porque el partido y la casa continúan avanzando.
- Las relaciones se descubren mediante nombres, equipos o conceptos destacados, no mediante un buscador libre en la jam.

## Caso de referencia (primer slice)

**Partido A — McLarens FC vs. Atlético Resaca** (derbi, contiene la contradicción).
**Partido B — Sporting Carbón vs. Dinamo Rotonda** (visible en paralelo, sin caso propio en este slice).

Periódico persistente, *Diario Gol Local* (tres piezas ya publicadas al empezar la ronda):

1. **"Convocatoria del derbi"** — Bruno Salas, delantero de McLarens FC, aparece en la lista de convocados. Tono neutro, sin alarmas.
2. **"Parte médico de ayer"** — molestia leve en el gemelo de Bruno Salas, calificada como "duda". Fuente algo desactualizada: es de ayer, no de hoy.
3. **"Rueda de prensa del técnico"** — *"Bruno está para jugar los 90 minutos"*. Fuente con sesgo conocido: un técnico rara vez confirma una duda en público.

Red inmediata (llega cerca del inicio del partido):

- **El Cortado** (contacto recurrente, cliente habitual del bar): especialidad cotilleo de vestuario, sesgo hacia el dramatismo, tasa de acierto media-baja con golpes certeros ocasionales. Aviso: *"Han visto a Bruno cojear en el calentamiento."*
- **Grupo Verde Siempre** (tipster ya nombrado en el universo original, doc. 01): especialidad pronósticos generales, sesgo hacia el optimismo y el favorito, tasa de acierto media. Resta importancia al rumor de El Cortado.

**Relación detectable:** el nombre "Bruno Salas" aparece en las tres piezas del periódico y en el aviso de El Cortado. Destacarlo en cada panel permite conectarlas sin buscador libre (ver D-019).

**Qué sabe cada parte:**

- *El partido (verdad oculta):* Bruno arrastra una molestia real que reduce su rendimiento en los primeros minutos y aumenta la probabilidad de sustitución si se agrava. Juega desde el inicio — el técnico no mintió, solo no dijo todo.
- *La casa:* no ha incorporado la duda física a la cuota inicial porque no hay confirmación oficial.
- *El jugador:* puede intuir el riesgo si conecta el parte médico de ayer con el aviso de El Cortado, pero Verde Siempre da una razón (débil) para dudar de esa lectura. Nunca hay certeza.

**Coste de investigar:** el aviso de El Cortado llega una sola vez y gratis; pedir una segunda opinión o esperar más confirmación consume la ventana antes del saque inicial y puede dejar pasar la cuota actual.

**Mercados de este caso:** ganador del derbi y línea de goles de McLarens FC (ambos ya en el scope de la jam).

## Hipótesis a validar

- Contrastar dos fuentes se siente como una decisión, no como lectura pasiva.
- Dos partidos simultáneos son tensos y legibles.
- El jugador entiende por qué cambia una cuota.
- Cobrar o mantener produce duda real.
- La experiencia genera deseo de repetir incluso tras una derrota.
