# Task board

## Preparación

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| Síntesis oficial y scope | Codex | Hecho | Los diez documentos compartidos son coherentes |
| Resolver U-001, U-002 y U-003 | Usuario | Hecho | Borracho mínimo, periódico + contactos y demo abierta confirmados |
| Concretar cadena informativa inicial | Claude | Hecho | Caso Bruno Salas entregado con periódico, contactos, contradicción, verdad oculta y coste temporal |

## Primer ciclo de código

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| C1: armazón jugable e integración Godot | Codex | Rechazado como experiencia | Se conserva solo como experimento técnico, no como base aprobada |
| C2: simulación de fútbol y cuotas | Claude | Rechazado como experiencia | Su código no se amplía hasta rediseñar la interacción |
| C3: bucle económico mínimo | Codex | Rechazado como experiencia | Apuestas y cashout deben replantearse desde el uso en pantalla |

## Integración y prueba

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| I1: integrar C1 y C2 | Codex | Cerrado sin validación | Integración técnica conseguida, resultado jugable rechazado |
| P1: prueba de fantasía y legibilidad | Usuario | Bloqueada por I1 | Puede explicar la contradicción, apostar y decidir cobrar/mantener sin ayuda |
| P2: siguiente corte o ampliación | Claude + Codex | Bloqueada por P1 | Se decide con evidencia si añadir combinada, borracho o más contenido |
| T2: validación estructural Godot | Codex | Hecho | Escena principal, autoload, contrato, focos y HUD verificados en archivos reales |
| T3: prueba headless Godot | Codex | Hecho | Proyecto importa y arranca; C2 completa traza reproducible con código de salida 0 |
| T4: prueba visual y de interacción | Usuario | Siguiente acción | Se verifica en ventana el bar, focos, legibilidad y ritmo |
| T5: prueba económica Godot | Codex | Hecho | Apuesta, bloqueo de duplicado, cashout y premio final pasan en Godot 4.7.1 |

## Dirección visual — fase activa

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| V1: master estático del bar | Codex | Hecho v1 | Encuadre, paleta y focos pueden evaluarse visualmente |
| V2: interfaz de máquina | Codex | Hecho v1 | Partidos, cuota, ticket y acciones son legibles |
| V3: reparto principal | Codex | Hecho v1 | Cinco personajes tienen siluetas y tono diferenciados |
| V4: interfaz del periódico | Codex | Hecho v1 | Tres noticias y sus relaciones se comprenden visualmente |
| V5: selección de dirección | Usuario + Claude | Hecho | Estilo v1 conservado; conexiones del periódico pasan a estado interactivo |
| V6: reconstrucción Godot con assets aprobados | Codex | Visual aprobado; interacción rechazada | Los assets marcan la dirección, no el comportamiento actual |
| V7: prueba visual en ventana | Usuario | Hecho | El usuario confirma que visualmente es el camino |

## Reinicio de interacción — fase activa

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| R1: guion interactivo de una decisión | Claude | Hecho | Secuencia periódico → relación → máquina → apuesta → saque inicial definida |
| R2: prototipo Godot de esa secuencia | Codex | Hecho | La secuencia manual completa funciona con visuales aprobados y sin simulación automática |
| R3: prueba del usuario | Usuario | Siguiente acción | El jugador confirma que la acción expresa la fantasía antes de reactivar simulación o economía |

## Sistemas funcionales sobre la secuencia aprobada

| Tarea | Responsable | Estado | Finaliza cuando |
|---|---|---|---|
| F1: HUD y recursos | Codex | Hecho | Dinero, cierre y suerte cambian por acciones reales |
| F2: apuesta configurable | Codex | Hecho | Importe 5–50 €, cuota capturada y una posición máxima |
| F3: partido y cuota | Claude + Codex | Hecho | Simulación arranca tras apostar y actualiza evento, minuto, marcador y cuota |
| F4: cashout y resolución | Codex | Hecho | Puede cerrar durante el partido o cobrar premio al minuto 90 |
| F5: prueba funcional automatizada | Codex | Hecho | Investigación, suerte, tiempo, apuesta, revelación y cashout pasan en Godot |
| F6: prueba de equilibrio y claridad | Usuario | Siguiente acción | Se valida si costes, importes y ritmo producen decisiones comprensibles |
| F7: correcciones funcionales de Claude | Claude | Hecho | Segunda TV visible, cashout vivo y recuperación tras apuesta fallida verificados |
| F8: prueba visual automatizada | Codex | Hecho | Cuatro estados capturados y revisados; TVs y controles de máquina corregidos |
| F9: verdad única de mercado | Codex | Hecho | Ambos partidos son seleccionables y cuota visible, capturada, cashout y resolución proceden del mismo snapshot; tres pruebas pasan |
| F10: pantallas sistémicas integradas | Codex | Hecho | Contactos, Lucía, mercado vivo y cierre diario modifican estado real y pasan prueba funcional y visual |
| F11: modelo de fuentes y fiabilidad | Claude | Siguiente | Un módulo aislado determina personalidad, coste, sesgo y tasa de acierto de cada contacto sin editar UI |

## Fuera del primer ciclo

- Arte final, tutorial separado y metaprogresión.
- Tenis, boxeo, megacasino y ojeador.
- Coberturas, seguros, venta parcial y mercados cruzados.
- Eventos extensos del bar y casa adaptativa.
