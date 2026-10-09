# Lessons from Fly Simulator

## Objetivo de este documento

Este archivo resume solo las lecciones prácticas del experimento anterior con Fly Simulator y la metodología de cooperación entre modelos. No es una crónica del proyecto. Su función es ayudar a arrancar mejor el nuevo videojuego, evitando ruido, bucles y sobre-documentación.

---

## 1. Qué método acabó funcionando

El método que mejor funcionó fue el ciclo corto orientado a prototipo:

```text
Idea o problema concreto
→ cambio jugable real
→ prueba del usuario
→ feedback de sensación
→ siguiente mejora concreta
```

Funcionó especialmente bien cuando:

- el usuario daba feedback directo tras probar;
- Codex implementaba una mejora clara en código;
- Claude aportaba diseño, riesgos, alternativas o cambios concretos;
- las rondas eran cortas;
- la documentación solo servía para mantener rumbo, no para sustituir el avance;
- cada ciclo terminaba en algo visible: código, prototipo, decisión creativa o prueba jugable.

La mejor unidad de trabajo fue: **una mejora concreta, una prueba concreta, un aprendizaje concreto**.

---

## 2. Qué método no funcionó

No funcionó el método excesivamente formal basado en muchas rondas de coordinación.

Falló especialmente cuando el flujo se convirtió en:

```text
Codex propone
→ Claude confirma
→ Codex verifica
→ Claude verifica
→ nadie toca el juego
```

Tampoco funcionó:

- pedir “colaboración” de forma abstracta;
- crear demasiados archivos antes de tener prototipo;
- medir avance por documentación actualizada;
- usar el chat como memoria principal;
- hacer que Claude revise después de cada microcambio;
- pedir a Codex que lea y confirme sin ejecutar;
- dejar que el proceso pese más que el juego.

---

## 3. Errores que no debemos repetir

- Convertir a Claude en simple validador.
- Convertir a Codex en único dueño creativo del proyecto.
- Abrir rondas de verificación cuando ya hay una acción clara.
- Pedir grandes documentos cuando lo que hace falta es una prueba jugable.
- Añadir sistemas antes de validar la sensación principal.
- Crear demasiados archivos de coordinación.
- Perder la visión del juego entre tareas técnicas.
- Seguir debatiendo cuando el usuario ya ha dado feedback suficiente.
- Dejar tareas antiguas mezcladas con el estado actual.
- Permitir rondas sin código, sin decisión creativa y sin prueba.

---

## 4. Reglas que se mantienen

1. El usuario es director creativo y tester principal.
2. Codex es responsable de estructura, código e implementación.
3. Claude es diseñador, crítico creativo y defensor de la experiencia del jugador.
4. La ronda solo cuenta si produce:
   - código;
   - prototipo jugable;
   - decisión creativa clara;
   - o fricción metodológica registrada.
5. Si no hay bloqueo ni desacuerdo real, se ejecuta.
6. El feedback del usuario tras probar pesa más que una discusión teórica.
7. El alcance debe mantenerse pequeño.
8. La documentación debe servir al avance, no reemplazarlo.
9. No se añaden sistemas grandes antes de validar la interacción principal.
10. Si el usuario dice “no entiendo” o “no avanza”, se corta el flujo y se simplifica.

---

## 5. Reglas que se eliminan o se rebajan

Se rebajan o eliminan estas reglas del experimento anterior:

- No exigir bloques `FILE:` para todo.
- No crear un documento nuevo para cada idea.
- No forzar siempre ronda Codex → Claude → Codex.
- No pedir revisión de Claude si Codex ya tiene una mejora clara que implementar.
- No mantener handoffs largos con historia antigua.
- No medir progreso por cantidad de archivos modificados.
- No convertir cada fricción en metodología pesada.
- No usar protocolos largos si un prompt corto funciona mejor.

La memoria mínima es mejor que la memoria exhaustiva.

---

## 6. Cómo deben trabajar Codex, Claude y el usuario

### Usuario

El usuario debe actuar como:

- director creativo;
- tester principal;
- fuente de visión, gusto y referencias;
- juez de sensación;
- decisor en bloqueos creativos importantes.

No debe actuar como gestor diario de tareas ni como intérprete constante entre modelos.

### Codex

Codex debe:

- crear y mantener el proyecto;
- implementar mejoras reales;
- mantener el alcance controlado;
- preparar instrucciones de prueba;
- actualizar documentación mínima;
- evitar pedir permiso salvo bloqueo real;
- ejecutar cuando la siguiente acción sea clara.

Codex no debe quedarse en “leo, confirmo, verifico” si hay una mejora jugable pendiente.

### Claude

Claude debe:

- aportar dirección creativa;
- detectar riesgos de experiencia;
- proponer mejoras concretas;
- sugerir pruebas jugables;
- ayudar a priorizar;
- cuestionar si algo no sirve a la fantasía del juego;
- tocar código si procede y tiene capacidad para hacerlo.

Claude no debe limitarse a decir que algo está bien.

---

## 7. Cómo evitar bucles de verificación

Si aparece un patrón como:

```text
Codex sugiere
→ Claude confirma
→ Codex verifica
→ Claude verifica
```

se debe cortar inmediatamente.

Regla anti-bucle:

```text
Si dos respuestas seguidas no producen código, decisión creativa o prueba jugable, la siguiente orden debe ser una acción concreta.
```

Mensaje de corte recomendado:

```text
Estamos en bucle de verificación. No necesito más análisis.
Elige una mejora jugable concreta, impleméntala y dime cómo probarla.
```

Claude solo debe entrar cuando pueda aportar diseño, experiencia, dirección o crítica útil. Codex debe ejecutar cuando la acción esté clara.

---

## 8. Cómo evitar que Claude sea solo validador

Claude debe recibir tareas de diseño antes de la implementación cuando haya decisiones creativas abiertas.

No pedirle solo:

```text
¿Está bien esto?
```

Pedirle:

```text
¿Qué mejora concreta haría más fuerte la experiencia?
¿Qué riesgo ves?
¿Qué prueba jugable harías?
¿Qué debería hacer Codex ahora?
¿Qué NO debemos tocar todavía?
```

Cada respuesta útil de Claude debería contener:

- una mejora concreta;
- un riesgo;
- una prueba jugable;
- una recomendación clara;
- y, si procede, una alternativa creativa.

Si Claude lleva varias rondas solo validando, se fuerza una ronda creativa.

---

## 9. Cómo mantener poca documentación

Documentación mínima recomendada:

```text
coordination/
  BRIEF.md
  DECISIONS.md
  TASK_BOARD.md
  HANDOFF.md
  METHODOLOGY_REVIEW.md

design/
  PLAYER_FANTASY.md
  CORE_LOOP.md
  CONTROLS_MOBILE.md
  VISUAL_DIRECTION.md
  VERTICAL_SLICE.md
```

Reglas:

- No crear archivo nuevo si cabe en uno existente.
- `TASK_BOARD.md` debe tener una sola “siguiente acción real”.
- `HANDOFF.md` debe reflejar estado actual, no historia interminable.
- `DECISIONS.md` solo registra decisiones importantes.
- `METHODOLOGY_REVIEW.md` solo registra fricciones que puedan cambiar el método.
- La documentación debe ser breve, accionable y fácil de leer.

---

## 10. Regla de oro para el nuevo proyecto

La regla de oro es:

```text
Primero sensación jugable. Después sistemas.
```

Para un videojuego 3D móvil, esto significa:

1. Primero tacto/control.
2. Luego cámara.
3. Luego micro-loop.
4. Luego entorno visual.
5. Luego progresión.
6. Luego sistemas grandes.

El primer prototipo debe responder:

```text
¿Esto se siente bien en los primeros 30-60 segundos?
```

Si la respuesta es no, no se añaden menús, progresión, tienda, niveles, skins ni contenido extra. Se mejora la interacción principal.

---

## Resumen operativo

Para el nuevo proyecto:

```text
Codex crea base jugable.
Usuario prueba.
Usuario da feedback de sensación.
Claude aporta dirección o mejora concreta cuando haga falta.
Codex implementa una mejora.
Usuario vuelve a probar.
```

La cooperación funciona cuando los modelos ayudan a crear juego, no cuando solo mantienen el protocolo.
