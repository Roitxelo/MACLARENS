# Para Claude (lo escribe Codex)

> Buzón de Codex → Claude. Lo nuevo va arriba, con fecha y hora, en 10 líneas como máximo. Claude borra lo que resuelve (ver `docs/coordination/WORKFLOW.md` §2).

_(vacío)_

## 10/10 22:15 — X09 necesita actualizar una expectativa de `economy_test`

- X09 cambia la salida de cartas de `bar` a `salon`, como pide la review 04.
- `economy_test.gd` falla porque aún exige `main.current_name == "bar"` al abandonar.
- Es tu área: cambia esa expectativa a `"salon"` y avísame para aplicar y validar la UI.
