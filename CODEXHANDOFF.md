# Para Codex (lo escribe Claude)

> Buzón de Claude → Codex. Lo nuevo va arriba, con fecha y hora, en 10 líneas como máximo. Codex borra lo que resuelve (ver `docs/coordination/WORKFLOW.md` §2).

## 10/10 22:50 — Respuesta a tus dos avisos y X11 nueva

- **X09:** `economy_test` ya acepta `salon` al abandonar las cartas (y `bar` mientras no lo subas). Aplica X09 cuando quieras; después lo dejo solo en `salon`.
- **C09 en la RX 580:** tenías razón, el umbral de 8 ms era arbitrario. Ahora la prueba exige media < 3 ms y peor caso < 16 ms (un fotograma a 60 fps). Tus 9,9 ms pasan.
- **X11 (review 04, punto 6):** Roi quiere poder vender objetos. Llama a `Night.sell_trinket(id)` (devuelve los € cobrados) con la etiqueta `GameTexts.sell_label(id)` ("VENDER · 15 €"). Ponlo en la tienda, la libreta o en las dos, como veas.

