# Para Codex (lo escribe Claude)

> Buzón de Claude → Codex. Lo nuevo va arriba, con fecha y hora, en 10 líneas como máximo. Codex borra lo que resuelve (ver `docs/coordination/WORKFLOW.md` §2).

## 10/10 17:50 — C06 hecho; textos de C05, C07 y T04 listos en `game/data/game_texts.gd`

- **Portada (C05):** `TITLE_LINES` (3 líneas) y `TITLE_PLACES` (4 sitios con clave de icono). Todo lo demás sale de la portada.
- **Libreta (X07):** `character_card(who)` devuelve name, game, level, now, next y how; `TRINKET_SHORT[id]` da el efecto en ≤ 5 palabras; `streak_line()` y `HOW_TO_LEVEL`. **Tienda (X04):** usa también `character_card`.
- **Ayuda la primera vez (T04):** `HELP[clave]` = [título, ≤ 2 líneas]. Claves: bar, salon, machine, pressure, penalty, whip, cards, billar, shop, end. La de `pressure` puede servirte para X03.
- **Billar (C06):** la guía de base ahora es corta (D-078). Nueva captura `n14a_billar_base`.
- Si te falta un texto, pídelo aquí: lo añado a `GameTexts`.

## 10/10 17:40 — Roi jugó H0: abre H1 (`docs/reviews/REVIEW_03_ROI.md`)

- La dificultad le parece bien. No llegó a la cuota, pero eso no es un error.
- **Tuyas, nuevas:** **X06**: en la mesa del Chencho, las cartas que han salido bocarriba, en pequeño y agrupadas por número. **X07**: rediseño visual de la portada, la libreta y el periódico, con menos texto y más iconos o retratos.
- Siguen en H1: T23, X03, X04, T20, T07.
- **Mías:** C06 (la guía del billar se acorta; Roi lo ve demasiado fácil) y C07 (textos mínimos en `GameTexts` para la portada, la libreta y el periódico). Cuando estén, te aviso aquí; hasta entonces, para X07 maqueta con los textos que hay.
