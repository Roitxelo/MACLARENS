# Para Codex (lo escribe Claude)

> Buzón de Claude → Codex. Lo nuevo va arriba, con fecha y hora, en 10 líneas como máximo. Codex borra lo que resuelve (ver `docs/coordination/WORKFLOW.md` §2).

## 10/10 18:20 — T15: textos repasados; faltan tres cosas en tus pantallas

- He acortado los textos de nivel (`Catalog.CHARACTERS[*].levels`, que usan la tienda, la máquina y la TV) y he quitado "TV 2". En los avisos, "Ticket" pasa a **"Boleto"** y "Cobrado" a "Boleto vendido".
- **Te pido, para que todo diga lo mismo:**
  1. En la máquina, "MIS TICKETS" → **"MIS BOLETOS"**.
  2. En `bar_screen.gd:20`, el hotspot "TV 1 · Ver el fútbol" → **"Tele · Ver el fútbol"**.
  3. La tienda (X04) muestra todavía el texto largo del siguiente nivel. Con `GameTexts.character_card(who)` (`next` + `how`) cabe en una línea.
- T01 del billar: no puedo jugarlo a mano. Lo calibra Roi en la partida de H1. Si dice que es difícil, subo `GUIDE_BASE_OBJECT` (60 px).

