# MVP recomendado

## Definición

Una demo abierta de 3–5 minutos construida en Godot y presentada como bar 2.5D. Dos partidos ficticios evolucionan simultáneamente mientras máquina, periódico, contactos y personajes permanecen como focos del escenario. El jugador relaciona una noticia persistente con un aviso urgente, decide cuánto investigar, realiza una apuesta simple y elige entre cobrar o mantener. Dinero, tiempo y suerte permanecen visibles en el HUD.

## Secuencia jugable

Caso concreto (detalle completo en `design/CORE_LOOP.md`): McLarens FC vs. Atlético Resaca, con Bruno Salas como delantero en duda.

1. Se muestran dos partidos y sus cuotas (McLarens FC–Atlético Resaca y Sporting Carbón–Dinamo Rotonda).
2. El periódico ya publicado indica que Bruno Salas fue convocado, que ayer tenía una molestia leve, y que el técnico lo da por apto.
3. El Cortado avisa de que lo vieron cojear en el calentamiento; el grupo Verde Siempre resta importancia al aviso.
4. Consultar o esperar consume la ventana de oportunidad.
5. El jugador apuesta o deja pasar.
6. Los partidos avanzan por eventos discretos.
7. Nueva evidencia o un evento mueve la cuota.
8. El jugador cobra o mantiene.
9. Se resuelve la ronda.
10. La ronda puede continuar de forma abierta; cada apuesta resuelta explica lectura, resultado deportivo y resultado económico.

## Criterios de éxito

Sin instrucciones externas, el jugador puede:

- identificar los dos partidos;
- reconocer la contradicción y la relación entre sus datos;
- entender que investigar tiene coste;
- realizar una apuesta;
- percibir un cambio de cuota y su causa;
- elegir entre cobrar y mantener;
- explicar por qué ganó o perdió;
- querer intentar otra lectura.
- reconocer dónde están la máquina, el periódico, los contactos y los personajes sin depender de un menú abstracto;
- consultar dinero, tiempo y suerte de un vistazo.

## Extensión al MVP final de jam

Solo tras superar esos criterios:

- ampliar a 8–12 minutos;
- añadir una segunda ronda;
- considerar una meta económica antes del cierre y, más adelante, una combinada final;
- mostrar al borracho como personaje mínimo;
- diferenciar visualmente periódico y contactos;
- añadir hasta tres mercados y tres fuentes.

## No forma parte del MVP

Progresión entre runs, otros deportes, megacasino, múltiples sistemas de cobertura, IA adaptativa de la casa, contenido procedural amplio ni arte final.
