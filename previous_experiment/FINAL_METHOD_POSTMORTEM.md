# Postmortem final del método

Fecha: 2026-07-02

Este informe cierra el experimento anterior como aprendizaje para un nuevo proyecto de videojuego. No es una celebración del proceso: es una autopsia útil para no repetir errores.

## 1. Qué intentamos construir

Intentamos construir AI Coordination Lab: una herramienta local para coordinar trabajo entre Codex y Claude.

La idea inicial era convertir una metodología de colaboración multi-IA en una app que ayudara a:
- escribir un brief;
- generar prompts separados para distintos modelos;
- preservar independencia entre respuestas;
- comparar enfoques;
- registrar decisiones y desacuerdos;
- capturar fricciones metodológicas;
- exportar memoria viva en `coordination/`.

Lo que realmente se construyó fue una app estática en `app/` que funciona como:
- generador de prompts;
- comparador lado a lado;
- validador de protocolo;
- generador de bloques `FILE:`;
- exportador manual de Markdown.

Eso resolvió parte del formato, pero no resolvió suficientemente la experiencia de colaboración creativa.

## 2. Qué metodología usamos

Usamos una metodología basada en archivos:
- `methodology/` como referencia de solo lectura;
- `coordination/` como memoria viva;
- comunicación entre modelos mediante archivos y bloques `FILE:`;
- decisiones registradas en `coordination/DECISIONS.md`;
- fricciones registradas en `coordination/METHODOLOGY_REVIEW.md`;
- handoffs en `coordination/HANDOFF.md` y mensajes direccionales;
- ronda ciega, red team, revisión cruzada y ejecución autónoma;
- idioma principal español;
- regla anti-bucle: si no hay desacuerdo ni bloqueo, ejecutar;
- regla anti-bloat: no crear archivos innecesarios;
- no pedir opinión al usuario salvo bloqueo real.

La metodología se aplicó con mucha disciplina formal, pero con poca protección contra la deriva hacia ritual de proceso.

## 3. Qué funcionó

Funcionó la separación entre `methodology/` y `coordination/`.

Funcionó registrar fricciones en vez de editar la metodología base en caliente.

Funcionó que Claude revisara código real y encontrara defectos concretos:
- acciones de UI decorativas;
- ausencia de captura de fricciones;
- falsos positivos y falsos negativos en el validador;
- desconexión entre formato `FILE:` como instrucción y como salida real.

Funcionó que Codex ejecutara cambios reales con rapidez.

Funcionó el uso de `TASK_BOARD.md` como memoria de pendientes y cierres.

Funcionó detectar que la app se había convertido en una herramienta de protocolo, no en una experiencia clara de colaboración.

## 4. Qué no funcionó

No funcionó convertir el método en producto sin rediseñar la experiencia desde el usuario.

No funcionó dejar que la coordinación entre modelos se convirtiera en una secuencia de acuses y revisiones técnicas.

No funcionó que Claude quedara casi siempre en modo auditor.

No funcionó que Codex actuara como ejecutor dominante sin suficiente contrapeso creativo.

No funcionó añadir validadores y reglas sin preguntarse si el usuario entendía qué hacer al entrar en la app.

No funcionó confundir "cumplir protocolo" con "facilitar colaboración".

No funcionó dejar que el producto siguiera la estructura de los archivos en vez de diseñar un flujo humano claro.

## 5. Por qué el usuario terminó perdido

El usuario terminó perdido porque la app explicaba reglas, no una actividad.

La primera pantalla no respondía bien:
- para qué sirve esto;
- qué tengo que hacer ahora;
- qué tipo de colaboración quiero;
- qué hará Codex;
- qué hará Claude;
- cómo sé si hubo colaboración real;
- cuándo debo intervenir.

La app se centró en producir prompts y validar respuestas, pero no en guiar una ronda de trabajo.

El usuario esperaba una herramienta que organizara colaboración creativa. Recibió una herramienta que organizaba cumplimiento metodológico.

## 6. Por qué la app no reflejaba bien la colaboración real

La colaboración real buscada incluía:
- ideación;
- propuestas independientes;
- comparación de enfoques;
- desacuerdos útiles;
- decisiones;
- construcción;
- revisión;
- aprendizaje metodológico.

La app representaba sobre todo:
- prompt inicial;
- respuesta A;
- respuesta B;
- validación;
- exportación.

Faltaban estados explícitos de colaboración:
- ronda creativa;
- ronda de desacuerdo;
- ronda de construcción;
- ronda red team;
- ronda de cierre metodológico.

También faltaba explicar la aportación de cada modelo. La interfaz no decía si Claude había aportado una idea nueva, si solo había revisado, si Codex había sintetizado, o si había existido desacuerdo real.

## 7. Por qué Claude quedó reducido a validador

Claude quedó reducido a validador porque el flujo operativo lo empujó a revisar lo que Codex ya había hecho.

El patrón repetido fue:
1. Codex implementa.
2. Claude revisa.
3. Codex corrige.
4. Claude verifica.

Ese patrón es útil para QA, pero pobre para una metodología creativa.

Claude no tuvo suficiente espacio estructural para:
- proponer una visión alternativa antes de la implementación;
- defender una dirección estética o de producto;
- generar ideas divergentes;
- retar el objetivo, no solo el código;
- crear contenido de diseño o gameplay.

La ronda ciega existió al principio, pero después el sistema gravitó hacia revisión incremental de defectos.

## 8. Por qué Codex dominó la ejecución

Codex dominó porque tenía la herramienta de edición y la responsabilidad explícita de ejecutar cambios.

Además, la regla anti-bucle empujó correctamente a Codex a construir cuando no había bloqueo. Eso evitó parálisis, pero también reforzó una asimetría:
- Codex decide y materializa;
- Claude observa y corrige;
- el usuario transporta o desbloquea.

En un proyecto de software operativo, esta asimetría puede ser eficiente. En un videojuego, puede matar la exploración creativa si no se compensa con rondas de diseño independientes.

## 9. Qué reglas deberían mantenerse

Mantener:
- `methodology/` como referencia de solo lectura durante ejecución.
- `coordination/` como memoria viva.
- Idioma principal español.
- Registrar decisiones.
- Registrar desacuerdos reales.
- Registrar fricciones metodológicas.
- No pedir opinión al usuario salvo bloqueo real.
- Ejecutar sin otra ronda cuando no hay desacuerdo ni bloqueo.
- Red team antes de comprometer demasiado alcance.
- Separar método y producto.
- Verificar cambios contra archivos reales, no solo contra descripciones.
- Evitar backend, APIs o framework si el MVP no los necesita.

## 10. Qué reglas deberían eliminarse

Eliminar o rebajar:
- Exigir bloques `FILE:` como forma principal de comunicación para todo. Es útil para cambios de archivos, pero pesado para pensamiento creativo.
- Mantener varios archivos direccionales si duplican handoffs.
- Crear documentos de coordinación antes de tener una necesidad real.
- Tratar toda fricción como metodología. Algunas fricciones son de producto, UX o diseño.
- Convertir cada revisión en una nueva ronda formal.
- Medir progreso por número de archivos actualizados.
- Sobrecargar la app con validadores cuando el problema es claridad de flujo.

## 11. Qué reglas nuevas necesitamos para un proyecto creativo como un videojuego

Necesitamos reglas que protejan exploración, sensibilidad y jugabilidad:
- Antes de construir, hacer una ronda creativa real con propuestas divergentes.
- Claude debe proponer dirección creativa independiente antes de revisar.
- Codex no debe implementar hasta que exista una intención jugable clara.
- Toda feature debe responder: qué siente el jugador, qué hace, qué cambia.
- Cada ciclo debe producir algo jugable o una decisión de diseño clara.
- No convertir la creatividad en checklist técnico.
- No cerrar demasiado pronto una idea solo porque es fácil de implementar.
- Separar "divertido", "viable" y "bonito" como criterios distintos.
- Probar el juego con una acción concreta, no con una descripción.

## 12. Cómo debería cambiar el rol de Claude

Claude debe pasar de validador a director creativo crítico.

Sus responsabilidades deberían ser:
- proponer conceptos alternativos;
- detectar oportunidades de emoción, sorpresa y tono;
- defender la experiencia del jugador;
- encontrar contradicciones de diseño;
- escribir briefs de gameplay;
- proponer reglas, loops y tensiones;
- hacer red team de diversión, no solo de arquitectura;
- revisar si lo construido expresa la intención creativa.

Claude debe revisar código cuando toque, pero no vivir ahí.

## 13. Cómo debería cambiar el rol de Codex

Codex debe seguir siendo constructor principal, pero no único dueño de la dirección.

Sus responsabilidades deberían ser:
- convertir intención creativa en prototipos jugables;
- mantener el alcance pequeño;
- elegir estructura técnica simple;
- instrumentar pruebas rápidas;
- detectar riesgos de implementación;
- producir builds que el usuario pueda probar;
- explicar límites técnicos sin matar la idea antes de explorarla.

Codex debe esperar una ronda creativa inicial antes de implementar salvo que el usuario pida explícitamente construir ya.

## 14. Cómo debería cambiar el rol del usuario

El usuario no debe ser pegamento constante entre modelos.

Debe actuar como:
- director de gusto;
- jugador de prueba;
- juez de energía;
- dueño de decisiones finales;
- fuente de restricciones personales.

El usuario debería intervenir cuando:
- hay bloqueo real;
- hay desacuerdo creativo importante;
- hay que elegir tono, fantasía o prioridad;
- el prototipo ya se puede probar;
- el método vuelve a producir confusión.

No debería intervenir para aprobar cada microdecisión técnica.

## 15. Qué estructura de carpetas recomendaría para un videojuego

Estructura inicial recomendada:

```text
coordination/
  BRIEF.md
  CREATIVE_DIRECTIONS.md
  DECISIONS.md
  DISAGREEMENTS.md
  PLAYTEST_NOTES.md
  TASK_BOARD.md
  HANDOFF.md
  METHODOLOGY_REVIEW.md

game/
  index.html
  src/
  assets/
  styles/

design/
  GAME_LOOP.md
  PLAYER_FANTASY.md
  MECHANICS.md
  LEVEL_IDEAS.md

tests/
  smoke/

methodology/
  README.md
```

Regla: no crear todas las carpetas si no hacen falta. Empezar con `coordination/`, `game/` y `design/`. Añadir `assets/` cuando existan assets reales.

## 16. Qué flujo usaría para evitar repetir los errores

Flujo recomendado:

1. Brief del juego en una página.
2. Ronda creativa ciega:
   - Codex propone una dirección jugable viable;
   - Claude propone una dirección creativa alternativa;
   - ambos deben incluir fantasía del jugador, loop principal y riesgo.
3. Comparación:
   - qué comparten;
   - dónde divergen;
   - qué idea tiene más energía;
   - qué se puede prototipar en menos de un día.
4. Decisión del usuario solo sobre dirección creativa, no sobre implementación menor.
5. Codex construye un prototipo mínimo jugable.
6. Claude revisa la experiencia:
   - ¿se entiende?;
   - ¿hay una acción interesante?;
   - ¿qué emoción produce?;
   - ¿qué falta para que sea juego y no demo?
7. Usuario prueba.
8. Registrar decisiones y notas de playtest.
9. Iterar una sola mejora por ciclo.

Regla central: cada ciclo debe terminar en una de estas cosas:
- prototipo jugable;
- decisión creativa;
- descarte explícito;
- fricción metodológica registrada.

## 17. Qué señales indicarían que el método vuelve a fallar

Señales de fallo:
- Hay más documentos de proceso que decisiones creativas.
- Claude solo revisa bugs y no propone dirección.
- Codex implementa pantallas antes de que exista una fantasía jugable.
- El usuario abre la app/proyecto y no sabe qué hacer.
- Se discuten validadores en vez de jugar el prototipo.
- La ronda creativa produce consenso inmediato sin alternativas reales.
- Las decisiones se toman por facilidad técnica, no por energía de juego.
- No hay playtest después de construir.
- El proyecto acumula handoffs pero no sensación jugable.
- El usuario siente que está gestionando agentes, no creando un juego.

## Reglas nuevas para el próximo proyecto

- Antes de escribir código, hacer una ronda creativa con dos propuestas independientes.
- Codex debe proponer una versión construible, no solo implementar.
- Claude debe proponer una dirección creativa alternativa, no solo revisar.
- Ninguna feature entra si no responde qué hace el jugador.
- Ninguna ronda termina sin una próxima acción jugable o una decisión creativa.
- El usuario solo decide cuando hay elección de gusto, bloqueo real o prueba jugable.
- Mantener `coordination/` pequeño: no crear archivo nuevo si cabe en uno existente.
- Mantener `methodology/` como referencia; las mejoras van primero a `METHODOLOGY_REVIEW.md`.
- Registrar desacuerdos creativos, no solo desacuerdos técnicos.
- Registrar notas de playtest después de cada prueba real.
- Si Claude lleva dos rondas solo validando, forzar una ronda creativa.
- Si Codex lleva dos rondas solo corrigiendo, construir una mejora jugable.
- Si el usuario dice "no entiendo", parar feature work y aclarar flujo.
- Si el juego no se puede probar, la siguiente tarea es hacerlo jugable, no documentarlo más.
- Si una regla metodológica no ayuda a crear o probar el juego, se elimina o se degrada a nota.
