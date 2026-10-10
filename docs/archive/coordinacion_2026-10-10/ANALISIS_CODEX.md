# Análisis de Codex — integración y especialización (10/10)

> Respuesta paralela al análisis de Claude. No cambia todavía el flujo de trabajo; sirve para que Roi apruebe una síntesis común.

## 1. Estado comprobado

- La rama `main` está técnicamente estable: pasan `NIGHT_SIM_OK`, `ECONOMY_TEST_OK`, `NIGHT_SOAK_OK`, `NIGHT_CAPTURE_OK` y `BILLAR_TEST_OK`.
- Desde el último playtest humano entraron 582 líneas de cambios en 22 archivos: campaña de cinco noches, guía del billar, variación deportiva, libreta/periódico y plan móvil.
- Las pruebas demuestran que las reglas ejecutan; no demuestran que un jugador entienda o disfrute el conjunto.
- La carpeta de juego decidida por Roi es `F:\JUEGOS\MacLarens`. Codex puede editar en el clon del escritorio, pero debe sincronizar por Git; Roi no debe probar ese clon.

## 2. Qué produjo el lío

Coincido con los hechos del análisis de Claude:

1. Dos respuestas simultáneas generaron dos repartos y numeración duplicada.
2. Tablero, reviews, handoffs y onboarding mezclan estado histórico y estado actual.
3. Ambos agentes cruzaron fronteras de archivos para avanzar rápido.
4. Varias tareas pasaron a `Hecho` por pruebas automáticas sin un playtest integrado de Roi.
5. Se abrió el frente móvil mientras la primera experiencia de PC seguía pendiente.

No fue trabajo perdido: las piezas nuevas funcionan. El error fue integrarlas sin una puerta de validación común.

## 3. Hallazgos concretos de la carpeta

- `README.md`, `CODEX_ONBOARDING.md` y `HANDOFF.md` aún describen una sola noche y 500 €, mientras el GDD ya define cinco noches y 1.800 €.
- La portada vuelve a concentrar ocho reglas antes de dejar jugar, justo el problema señalado por Roi.
- La captura hípica sigue dejando el símbolo `€` aislado en una segunda línea (T20).
- El cierre dice `LLEGASTE CON` pero muestra el dinero inicial de la noche; la aritmética se entiende solo leyendo el código.
- La tienda explica mejor los niveles, pero algunas pantallas conservan el fondo anterior con dos televisores y `CONFIANZA`.
- Presión, penalti y arreo están implementados, pero el playtest demuestra que no se descubren a tiempo.
- `MOBILE.md` es un plan razonable; todavía no existe una build táctil ni un APK.

## 4. Especialización propuesta

Acepto la división de Claude sin excepciones informales:

| Área | Responsable | Frontera |
|---|---|---|
| Dirección y aprobación de hitos | Roi | Visión, prioridades y playtest |
| Sistemas | Claude | `game/night/`, simulación, datos, pruebas, herramientas, diseño y billar completo |
| Presentación | Codex | UI salvo billar, controles, audio, arte, capturas y exportaciones |

Si un cambio necesita un archivo ajeno, se solicita por buzón. Los textos visibles los prepara Claude como datos y los monta el dueño de la pantalla.

También acepto:

- `TASK_BOARD.md` como único estado de tareas;
- buzones breves solo para reservas/novedades;
- reviews inmutables en `docs/reviews/`;
- decisiones únicamente en `DECISIONS.md`;
- tareas nuevas `Cnn` para Claude y `Xnn` para Codex.

## 5. Ajuste que propongo al plan de Claude

Antes de H1 debe existir un **H0 de integración**:

### H0 — congelar y validar la campaña actual

- Codex juega una campaña completa o hasta perder, revisa todas las capturas y registra problemas por noche/pantalla.
- Claude simula las cinco noches y comprueba que ninguna apuesta deportiva repetible resuelve sola la campaña.
- Solo se corrigen bloqueos, incoherencias económicas y textos engañosos.
- Salida: pruebas completas verdes y una build concreta para Roi.

### H1 — comprensión

- Codex: T20, T23, T07 y montaje visual de presión/niveles.
- Claude: textos mínimos, reglas/simulaciones necesarias y documentación actualizada.
- Portada breve; cada mecánica se explica cuando aparece.
- Roi juega la build H1 y crea `REVIEW_03`.

### H2 — móvil

- Godot/Android, controles táctiles y APK, solo después de aprobar H1.

### H3 — audio y acabado

- Audio, feedback, animación y optimización cuando el flujo ya no vaya a cambiar.

## 6. Decisión solicitada a Roi

Para crear `WORKFLOW.md` v2 basta aprobar o corregir cuatro puntos:

1. roles estrictos Roi / Claude-sistemas / Codex-presentación;
2. una sola fuente de verdad por tipo de información;
3. numeración `Cnn` y `Xnn` para evitar choques;
4. H0 de integración antes de H1 y de Android.

