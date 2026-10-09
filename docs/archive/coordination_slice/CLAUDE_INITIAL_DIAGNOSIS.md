# Diagnóstico inicial de Claude (ronda independiente)

Fecha: 2026-07-21
Estado: primera ronda, sin haber leído las conclusiones de Codex.
Fuentes usadas: `source_docs/00_Vision_y_Pilares.md`, `source_docs/01_GDD_Inicial.md`,
`previous_experiment/LESSONS_FROM_FLY_SIMULATOR.md`, `previous_experiment/FINAL_METHOD_POSTMORTEM.md`,
referencias visuales de Do Not Feed the Monkeys.

---

## 1. Fantasía principal

Estar en el bar y saber algo que la casa todavía no ha metido en la cuota. No es "ganar apostando", es "detectar la ventaja antes que el sistema".

## 2. Core loop en una frase

Contrastar fuentes contradictorias bajo presión de tiempo → apostar con esa lectura → ver el partido evolucionar en varias pantallas a la vez → reaccionar en directo (cobrar / cubrir / mantener) → repetir con la presión subiendo hasta la combinada final.

## 3. Primer minuto

El jugador debe: ver 2 partidos en marcha, tropezar con una contradicción concreta entre dos fuentes (no una lista de webs), y poder hacer una apuesta pequeña ya. La sensación buscada es "tengo una pista y tengo que decidir ya, no tengo todos los datos". Si el primer minuto enseña menús o recursos (atención, credibilidad) antes que esa fricción, se pierde el gancho.

## 4. Pilares no negociables

- Información incompleta + contraste de fuentes (5.1/5.3).
- Probabilidades dinámicas — nunca certezas (5.2).
- Riesgo modificable en directo, al menos cobro anticipado (5.4).
- Varios partidos visibles a la vez (5.5).
- Tono absurdo-ficticio, nunca simulador serio (sección 6 y 12).

Todo lo demás (roguelite entre runs, megacasino, ojeador, casa que "aprende") es identidad del juego completo, pero no pilar de MVP de jam.

## 5. MVP mínimo realista

Más pequeño que el "alcance recomendado" del propio Doc 01 (que ya es demasiado para un jam: 3 TVs, 4 equipos, 6 mercados, 3 contactos de Telegram, borracho, 3 jornadas).

Propuesta: 1 deporte (fútbol), 2 partidos simultáneos esquemáticos, 2 fuentes de información que puedan contradecirse en un mismo dato, apuesta simple (sin combinada todavía), simulación por intervalos con 3-4 tipos de evento, cuota que se mueve en vivo, y una sola acción en directo: cobro anticipado. Sin Telegram completo, sin progresión entre runs, sin megacasino.

## 6. Qué cortaría o pospondría

Tenis y boxeo, megacasino y ojeador, progresión entre runs, combinadas y sinergias, cobertura/venta parcial/seguro/auditoría/alerta (dejar solo cobro anticipado), recursos credibilidad y atención, Telegram como app completa (bots, favores, chats de pago), StatZone/ForoBet/CuotaCompare/StreamPirata/Correo (máximo 2 fuentes para el jam), eventos de bar como sistema (policía, deudas, cierre), "la casa aprende" como IA real.

## 7. Tres ideas nuevas — compatibles con la visión

- **Choque visual de contradicción**: cuando dos fuentes se contradicen sobre el mismo dato, un efecto simple (parpadeo/subrayado) las conecta visualmente, para que la fricción se note sin obligar a leer todo el texto. Refuerza el pilar 5.3 con coste de implementación bajo.
- **Cuota como ticker vivo**: la cuota sube/baja de forma visible en cada TV en tiempo real (estilo bolsa), dando la sensación de que "la casa también reacciona" sin necesitar IA adaptativa real. Sustituto barato de "la casa aprende" para el jam.
- **Micro-interrupciones de bar**: 1-2 eventos mínimos (ej. cerveza derramada en el teclado, 3s de pantalla bloqueada) en vez del sistema completo de eventos. Barato, y mete caos de bar desde el primer prototipo.

## 8. Riesgo principal de diseño

Que "contrastar fuentes" se sienta como leer texto pasivo en vez de una decisión tensa. El pilar 5.5 (todos los partidos a la vista) puede chocar con legibilidad si no se resuelve el layout pronto — es una tensión real del propio documento, no solo mía.

## 9. Riesgo principal de alcance

El propio Doc 01 ya arrastra un GDD de juego completo (5 superficies de interfaz, 3 deportes, decenas de webs, progresión, megacasino) a la fase de jam. Es exactamente el patrón que advierte `LESSONS_FROM_FLY_SIMULATOR.md`: "implementar sistemas grandes antes de validar la sensación básica".

## 10. Primer prototipo a construir

Una sola "ronda de decisión": 2 partidos simulándose en paralelo, 2 fuentes contradictorias sobre un dato concreto, una apuesta, evolución en vivo, y un cobro anticipado. Sin arte final, sin menús, sin progresión. Objetivo: validar si contrastar es divertido y si dos pantallas simultáneas generan tensión legible.

## 11. Módulo que lideraría yo, con código

El motor de simulación por intervalos y cuotas dinámicas (sección 6 del GDD): generación de eventos de fútbol a partir de stats + probabilidades, y cómo esos eventos mueven la cuota. Es un módulo aislado, testeable por logs antes de tener UI, y es el corazón de "probabilidades dinámicas" — encaja con diseño+balance. También lideraría el contenido/guion de las 2 fuentes contradictorias iniciales.

## 12. Qué debería liderar Codex

La arquitectura jugable del centro de control: estructura de escena/UI, cómo se renderizan las 2 TVs y el panel de apuestas, el bucle de tiempo real, y cómo esa UI consume los datos que salen de mi motor de simulación. En corto: todo lo que convierte el motor en algo tocable en pantalla.

## 13. Preguntas al usuario (solo las que tocan identidad)

- ¿El borracho debe aparecer aunque sea de forma mínima en el primer prototipo (es muy identitario del tono), o se pospone del todo arriesgando perder ese sabor desde el principio?
- ¿Telegram debe existir aunque sea como un simple feed de mensajes en una ventana, o se puede sustituir temporalmente sin romper la fantasía de "móvil con contactos"?
- ¿El prototipo de jam necesita una condición de cierre (ganar/perder una "última combinada" corta), o basta con una demo abierta de unos minutos sin fin definido?

---

## Recomendación concreta

Construir primero, y solo, el prototipo del punto 10 (2 partidos, 2 fuentes contradictorias, 1 apuesta, cobro anticipado) antes de tocar Telegram, borracho, progresión o megacasino. Claude empieza por el motor de simulación/cuotas en paralelo a que Codex monte el armazón de UI, y ambos convergen cuando haya algo jugable de 3-5 minutos que se pueda probar. No se toma ninguna decisión sobre Telegram/borracho/condición de cierre hasta tener ese prototipo en la mano — las preguntas del punto 13 se responden mejor jugando que hablando.

---

```
HANDOFF_FOR_CODEX

Contexto: McLarens: La última combinada. Roguelite de inteligencia deportiva
(bar de apuestas, interfaz diegética, información incompleta, cuotas dinámicas).
Visión completa en source_docs/00_Vision_y_Pilares.md y source_docs/01_GDD_Inicial.md.
No hay biblia nueva: este handoff es la única guía de alcance para el primer ciclo.

Pilares no negociables para cualquier build:
- Información incompleta y fuentes que pueden contradecirse.
- Probabilidades dinámicas: la información nunca da certeza, solo ajusta cuota.
- Al menos una acción de riesgo en directo (cobro anticipado).
- Mínimo 2 partidos visibles y simulándose a la vez.
- Tono absurdo/ficticio, no simulador serio.

Primer prototipo a construir (nada más que esto):
- 1 deporte (fútbol), 2 partidos esquemáticos en paralelo.
- Simulación por intervalos con 3-4 tipos de evento (gol, tarjeta, lesión, córner).
- 2 fuentes de información que puedan contradecirse sobre un mismo dato.
- Apuesta simple (sin combinadas todavía).
- Cuota que se mueve en vivo según eventos.
- Una sola acción en directo: cobro anticipado.

Explícitamente fuera de este ciclo: Telegram completo, borracho, tenis/boxeo,
combinadas/sinergias, cobertura/venta parcial/seguro/auditoría/alerta,
recursos credibilidad/atención, progresión entre runs, megacasino, ojeador,
"casa que aprende" como IA real (si hace falta sensación de casa reactiva,
usar solo un ticker de cuota visible, no un sistema de aprendizaje).

División de trabajo:
- Claude: motor de simulación por intervalos + lógica de cuotas dinámicas
  (aislado, testeable por logs), y contenido/guion de las 2 fuentes
  contradictorias iniciales.
- Codex: arquitectura jugable del centro de control (UI de las 2 TVs,
  panel de apuesta, bucle de tiempo real), consumiendo el output del
  motor de Claude. Construir sin pedir permiso en microtareas técnicas
  claras; parar solo si hay bloqueo real o decisión de diseño abierta.

Regla del ciclo: el ciclo termina cuando hay algo jugable de 3-5 minutos
probable por el usuario, no cuando la lista de features esté completa.

Decisiones pendientes del usuario (no técnicas, no bloquean el prototipo):
- Si el borracho entra en el primer prototipo o se pospone.
- Si Telegram debe existir aunque sea mínimo, o se sustituye por un feed simple.
- Si el prototipo necesita condición de cierre (última combinada corta) o
  es una demo abierta.
```
