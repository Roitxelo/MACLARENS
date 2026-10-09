# Lessons From Fly Simulator

Este documento no es una cronica. Es una lista practica para arrancar mejor el nuevo juego 3D movil.

## 1. Metodo que acabo funcionando

- Ciclos cortos: construir, probar, decidir y ajustar.
- Cada ronda debe producir algo real: codigo, prototipo jugable, decision creativa clara o friccion metodologica registrada.
- `coordination/` funciona como memoria viva, no como archivo historico exhaustivo.
- `design/` debe describir fantasia, loop, controles y slice, no convertirse en biblia.
- Codex avanza sin pedir permiso para microtareas tecnicas.
- El usuario interviene cuando hay gusto, vision, bloqueo real o prueba jugable.
- Las decisiones se registran poco y pronto, antes de que se pierdan.

## 2. Metodo que no funciono

- Convertir la colaboracion en protocolo pesado.
- Medir progreso por documentos actualizados.
- Pedir validaciones repetidas cuando no hay desacuerdo real.
- Usar a Claude solo para revisar lo que Codex ya hizo.
- Crear estructura antes de tener una necesidad jugable.
- Confundir "cumplir el metodo" con "mejorar el juego".

## 3. Errores que no debemos repetir

- Implementar sistemas grandes antes de validar la sensacion basica.
- Arrastrar fantasia, controles o prioridades del proyecto anterior.
- Documentar mas rapido de lo que se juega.
- Dejar que el usuario sea pegamento entre agentes.
- Hacer que cada duda se convierta en una ronda formal.
- Construir menus, progresion, tienda, skins o arte final antes del control.
- Aceptar prototipos que funcionan tecnicamente pero no invitan a repetir.

## 4. Reglas que se mantienen

- Espanol como idioma principal de coordinacion.
- Alcance pequeno por defecto.
- Registrar decisiones en `coordination/DECISIONS.md`.
- Registrar fricciones metodologicas en `coordination/METHODOLOGY_REVIEW.md`.
- Mantener `coordination/TASK_BOARD.md` como tablero simple.
- No pedir permiso salvo bloqueo real o decision creativa importante.
- Si no hay bloqueo ni desacuerdo, Codex ejecuta.
- Verificar con prototipo o archivos reales, no con intenciones.
- Primero control y sensacion; despues contenido.

## 5. Reglas que se eliminan o se rebajan

- No hace falta crear documentos nuevos si cabe en los existentes.
- No hace falta una ronda formal para cada cambio menor.
- No hace falta que Claude valide todo.
- No hace falta conservar largas cronicas del proceso.
- No hace falta resolver toda la metodologia antes de jugar.
- Los handoffs deben ser breves y accionables.
- Las reglas metodologicas que no ayuden a construir o probar se rebajan a notas.

## 6. Como deben trabajar Codex, Claude y el usuario

Codex es technical game lead:

- convierte intencion creativa en prototipos jugables;
- mantiene el alcance pequeno;
- decide microarquitectura y estructura tecnica;
- prepara instrucciones de prueba;
- registra decisiones minimas;
- no espera aprobacion para tareas tecnicas claras.

Claude debe ser director creativo critico, no solo auditor:

- propone alternativas de fantasia, tono, loop o experiencia;
- detecta contradicciones de diseno;
- revisa si lo construido expresa la intencion;
- hace red team de diversion, claridad y emocion;
- revisa codigo solo cuando eso desbloquea una mejora real.

El usuario es director creativo y tester principal:

- define vision, gusto y referencias;
- prueba prototipos;
- decide entre direcciones creativas importantes;
- no gestiona microtareas tecnicas;
- no tiene que coordinar agentes salvo bloqueo.

## 7. Como evitar bucles de verificacion

- Una revision solo se abre si puede cambiar una decision, encontrar un riesgo real o mejorar el prototipo.
- Si dos respuestas coinciden y no hay bloqueo, se ejecuta.
- Si falta informacion, hacer una sola pregunta corta.
- Si la pregunta no cambia la accion inmediata, no se pregunta.
- Despues de corregir un problema pequeno, no pedir otra ronda: probar o avanzar.

## 8. Como evitar que Claude sea solo validador

- Involucrarlo antes de implementar cuando haya direccion creativa abierta.
- Pedirle alternativas, no solo defectos.
- Hacer que evalua la fantasia del jugador, no solo bugs.
- Si lleva dos rondas solo validando, la siguiente intervencion debe ser creativa.
- Si Codex ya construyo, Claude debe responder: que emocion aparece, que falta, que sobra y que probaria despues.

## 9. Como mantener poca documentacion

- Maximo documentos base: brief, decisiones, tablero, handoff, metodologia, fantasia, loop, controles, direccion visual y slice.
- Cada documento debe responder a una accion futura.
- Borrar o resumir lo que ya no guie decisiones.
- No duplicar lo mismo en varios archivos.
- Las notas largas van fuera del flujo principal o no se escriben.
- Una buena decision registrada vale mas que una explicacion perfecta.

## 10. Regla de oro

El nuevo proyecto solo avanza si algo se puede jugar, decidir o mejorar. Si una ronda no acerca el juego a una sensacion probada en movil, hay que recortarla, convertirla en pregunta corta o saltarla.
