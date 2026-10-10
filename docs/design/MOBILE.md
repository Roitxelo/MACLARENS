# Versión móvil (T28)

> Roi (10/10): "Con Godot o Flutter, lo que lleve menos trabajo y quede mejor, pero no quiero pagar."

## Recomendación: Godot exportando a Android, gratis

| | **Godot (export Android)** | **Flutter (+ Flame)** |
|---|---|---|
| Qué hay que hacer | Adaptar los controles al táctil y agrandar los textos. El código del juego es el mismo | Reescribir todo en Dart: reglas de la noche, 3 simulaciones (fútbol, caballos, billar), 4 minijuegos, unas 15 pantallas |
| Trabajo estimado | **2-4 días** | **4-8 semanas** |
| Códigos que mantener | 1 | 2 (PC en Godot y móvil en Flutter), cada cambio dos veces |
| Riesgo | Bajo: Godot 4 exporta a Android de serie y ya usamos el renderer recomendado para móvil (`gl_compatibility`) | Alto: la física del billar y las cuotas tendrían que dar exactamente lo mismo |
| Coste en € | 0 | 0 |

Flutter no aporta nada que este juego necesite. Es mejor para aplicaciones de formularios y listas; para un juego 2D con arte pixel y física, Godot ya es la herramienta adecuada.

## Cómo publicar sin pagar

- **Android, 0 €:** se genera un `.apk` y se sube a **itch.io** (gratis), o se pasa directamente. Las herramientas son todas gratuitas: Android SDK, OpenJDK, plantillas de exportación de Godot y una keystore propia.
- **Google Play:** cuesta una cuota única de 25 $ por la cuenta de desarrollador. Queda fuera mientras no se quiera pagar.
- **iPhone:** para publicarlo hace falta un Mac y la cuenta de Apple Developer (99 $ al año). Sin pagar, solo se puede instalar en tu propio iPhone desde un Mac, y la instalación caduca a los 7 días. Pasa lo mismo con Flutter. Propuesta: **solo Android** por ahora.

## Qué hay que cambiar en el juego

Godot convierte el toque en clic por defecto (`emulate_mouse_from_touch`), así que casi todo funciona ya. Lo que no:

| Problema en móvil | Dónde | Solución | Dueño |
|---|---|---|---|
| Arrear con ESPACIO | `race_screen.gd` | Botón grande "¡ARREA!" (y tocar la pista) | Codex |
| Afinar el billar con ← → | `billar.gd` | Botones ◀ ▶ junto a la mesa; apuntar arrastrando y tirar con un botón "TIRAR" que se mantiene pulsado | Claude |
| Pausa con P y volver con ESC | `hud.gd`, `night_main.gd` | Ya hay botones de pausa y velocidad en el HUD. Falta un botón "VOLVER" fijo en cada pantalla | Codex |
| Información que solo sale al pasar el ratón (tooltips) | Varios | Toda información importante, escrita en la pantalla | Codex |
| Textos de 15-17 px: en un móvil de 6" miden ~2 mm | Libreta, tienda, máquina | Mínimo 20 px en texto que haya que leer | Los dos, cada uno en sus pantallas |
| Botones pequeños | Máquina (+/−), lobby del billar | Zonas de toque de 48 px o más | Codex (T23) |
| Proporción 19,5:9 de los móviles | `project.godot` | `stretch/aspect = expand` y orientación horizontal fija | Codex |

## Plan

1. **Ya mismo:** todo lo que hagamos nuevo nace táctil (regla en `CODEXHANDOFF.md`).
2. **T29 (Codex):** preset de Android y `.apk` de prueba (va junto a T03, el export a Windows).
3. **T30 (los dos):** pasada táctil de la tabla anterior, cada uno en sus pantallas.
4. **T31 (Roi):** probarlo en su móvil y decir qué molesta.

La diferencia con *Gamble With Your Friends* no viene de la plataforma: viene del bar de barrio, sus personajes, las apuestas deportivas en directo, los minijuegos de habilidad y la deuda repartida en cinco noches.
