# Flujo de la noche (versión final de jam)

> Sustituye al slice de una sola apuesta (`scenes/main_bar.tscn`), que se conserva intacto como referencia.
> Escena principal nueva: `scenes/night.tscn`.
> Versión 3 (09/10 noche): sin rumores; cada juego tiene un personaje con 3 niveles, objetos de habilidad en la barra de Lucía y una racha moderada (máx. x1,5).

## La run

- **Una run = una noche en el McLarens, de 18:00 a 02:00.**
- Empiezas con **100 €**. Tino viene a las 02:00 a cobrar **500 €**.
- El reloj corre solo (0,6 min de juego por segundo real → ~13 min por noche a x1). Botones de pausa (P) y velocidad x1/x2/x4 en el HUD. ESC vuelve al bar.
- La noche termina a las 02:00 o antes si te quedas sin dinero y sin tickets abiertos.
- HUD: dinero, hora, suerte (3 estrellas) y una pizarra con lo próximo de la agenda.

## Filosofía (v3, 09/10 22:19)

Las mejoras no regalan dinero: dan **herramientas que premian jugar bien**. Apostar a ciegas pierde a la larga (margen de la casa); la ventaja sale de leer el partido, arrear a tiempo, contar cartas y dominar el futbolín.

## Personajes: un juego, un personaje, tres niveles

| Personaje | Juego | Cómo sube | Nv1 | Nv2 | Nv3 |
|---|---|---|---|---|---|
| El Búho (ayuda) | Fútbol | Ronda (35 / 70 €) | Medidor de PRESIÓN (momento del partido; la casa no lo mete en la cuota) | Presión con % de gol a 10' y cobro anticipado sin comisión | Un penalti por partido que tiras tú (minijuego de puntería) |
| El Cortado (ayuda) | Caballos | Ronda (35 / 70 €) | Ganador | 3 ARREOS de timing por carrera (TV 2) | 5 arreos y apuesta a COLOCADO (cuota/3) |
| El Chencho (rival) | Mayor o menor | Ronda (25 / 60 €) | Calcula bien, mesa 20 € | Mesa 40 € y SEGURO por mano (si fallas tras acertar, salvas la mitad) | Mesa 60 € y paga con probabilidades de baraja entera: contar cartas da ventaja |
| Tino (rival) | Futbolín | Ganándole | 20 € | 40 €, juega mejor | 60 €, difícil. La primera victoria rebaja 100 € de deuda |

### Minijuegos de habilidad
- **Arreo (caballos):** una aguja va y viene; ESPACIO en lo verde = acelerón (perfecto en lo verde claro); fuera = el caballo se asusta. La carrera se simula en directo.
- **Penalti (fútbol):** la mirilla recorre la portería; el portero tapa un tercio al azar. Pegado al palo entra siempre; fuera de los palos es fuera.
- **Presión (fútbol):** el partido tiene momento; quien aprieta tiene más opciones de gol durante unos minutos. Entrar o cobrar en el momento justo es la habilidad.
- **Cartas:** siempre se ve el historial de la mano. Con el Chencho borracho las cuotas ignoran las cartas ya salidas.

## La barra de Lucía (tienda)

Rondas para subir de nivel, 3 objetos rotativos (cada 90 min o 5 €, máx. 5 en inventario) y chupito de orujo (15 € → +1 suerte).

## Objetos (todos de habilidad o información)

| Objeto | € | Efecto |
|---|---|---|
| Portero de plomo | 25 | Tu portero del futbolín es más ancho |
| Mango de goma | 25 | Chut cargado: la ventana del clic dura más y la bola sale más fuerte |
| Tiza azul | 20 | La bola del futbolín va un 15 % más lenta |
| Muñeco cojo | 30 | Tu primer gol del futbolín vale doble |
| Fusta nueva | 25 | +2 arreos y zona verde más ancha |
| Gafas de culo de vaso | 25 | Ves qué caballo viene en forma |
| Herradura oxidada | 20 | Si tu caballo llega 2.º a ganador, recuperas hasta 20 € |
| Silbato de árbitro | 25 | En el penalti el portero tapa menos |
| Prismáticos | 20 | El medidor de presión también en la tele del bar |
| Chuleta | 25 | En las cartas ves cuántas mayores y menores quedan |
| Moneda de dos caras | 25 | Una vez por noche, un fallo en las cartas cuenta como empate |
| Calcetín de la suerte | 20 | La primera derrota de cada racha no la rompe |
| Trébol de plástico | 20 | +1 corazonada máxima y +1 ahora |
| Chapa de Lucía | 15 | Rondas un 40 % más baratas |

## Racha

+0,1 al multiplicador del beneficio por cada victoria previa seguida, **tope x1,5**. Solo apuestas de 10 € o más. Una derrota la rompe.

## Corazonadas (3 por noche): ayudan a ejecutar, no regalan resultados

- Futbolín: 6 s de cámara lenta (tus barras a velocidad normal).
- Caballos: el siguiente arreo sale perfecto.
- Penalti: el portero se tira al lado contrario.
- Cartas: ves la siguiente carta.

## Combos pensados

- **Leer el partido:** Búho Nv2 + Prismáticos. Apuesta en directo cuando un equipo aprieta y la cuota aún no se ha movido; cobra sin comisión cuando cambie el viento. En Nv3, penalti + Silbato.
- **El tapado:** Gafas + Fusta + Cortado Nv3. Elige el caballo en forma que la casa paga largo y arréale bien.
- **El contador:** Chencho Nv3 + Chuleta (+ Moneda). Cuenta las cartas contra un borracho que paga como si la baraja estuviera entera.
- **Ajuste de cuentas:** Portero + Mango + Tiza (+ cámara lenta) para tumbar a Tino Nv3 y quitarte 100 € de deuda.

## Calibración comprobada

- Caballos: apostando a todos por igual se recupera ~91 % (margen de la casa); el favorito gana ~43 %. Las carreras duran ~8 minutos de reloj (~14 s reales a x1).
- Dos noches con apuestas aleatorias: terminan con 181 € y 2 € (sin dinero fácil).

## Código

- `night/night_state.gd` (autoload `Night`): reloj, dinero, suerte, tickets, agenda, corazonadas, fin de noche.
- `night/football_market.gd`: los dos partidos sobre `MatchSimulator` + cuotas 1X2.
- `night/horse_races.gd`: 10 carreras, cuotas, orden de llegada y animación.
- `night/catalog.gd`: personajes, niveles, objetos y fórmula de la racha.
- `night/info_board.gd`: (sin uso) rumores de la versión anterior.
- `ui/night_main.gd`: navegación entre pantallas, HUD y avisos.
- `ui/screens/*`, `ui/minigames/*`, `ui/widgets/*`: pantallas, futbolín, cartas, TVs.
- Pruebas: `tests/night_sim_test.tscn` (lógica, headless), `tests/night_capture.tscn` (capturas de todas las pantallas), `tests/night_soak_test.tscn` (dos noches completas con apuestas aleatorias).

## Ajustes rápidos de equilibrio

- Deuda, dinero inicial, duración: constantes al principio de `night/night_state.gd`.
- Horario de carreras: `FIRST_RACE`, `INTERVAL` en `night/horse_races.gd`.
- Niveles, precios de rondas, objetos: `night/catalog.gd`.
