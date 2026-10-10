# GDD — McLarens: La última combinada

> Documento de diseño **vivo**: si cambias una regla del juego, cámbiala aquí en el mismo commit.
> Versión 3 (09/10/2026): sin rumores; cada juego tiene un personaje con 3 niveles, objetos de habilidad en la barra de Lucía y una racha moderada (máx. x1,5).
> Escena principal: `game/scenes/night.tscn`. El prototipo anterior (slice de julio) está en la rama `archive/slice-julio` y en `docs/archive/`.

## La run

- **Una run = una campaña de 5 noches en el McLarens**, cada una de 18:00 a 02:00 (D-073).
- Empiezas con **200 €**. Tino cobra al cierre de cada noche: **100 / 150 / 300 / 500 / 750 €** (1.800 € en total). Si no llegas, se acaba la campaña; si pagas la quinta, ganas.
- Entre noches se conservan el dinero que te queda, los niveles de los personajes y los objetos. Se reinician la suerte, la racha y los boletos.
- Cada noche es distinta: los partidos cambian de hora (±45 min en cuartos de hora), McLarens FC cambia de franja y de campo, y las carreras se sortean de nuevo.
- La máquina admite boletos de **hasta 50 €** y no paga más de **15 a 1** en caballos (D-074).
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
| El Chencho (rival) | Mayor o menor | Ronda (25 / 60 €) | Calcula bien, mesa 20 € | Mesa 40 € y SEGURO por mano (si fallas tras acertar, salvas la mitad) | Mesa 60 €, no baraja entre manos y paga con probabilidades de baraja entera: contar cartas da ventaja |
| Tino (rival) | Billar "Tiro imposible" | Ganándole una serie | Paga 1:1 (apuesta 10–30 €), tiros de calentamiento | Paga 3:2 (10–60 €), tiros con truco (banda, carambola, pasillo) | Paga 2:1 (10–100 €), los imposibles. La primera serie ganada rebaja 100 € la cuota de la **última** noche (una vez por campaña, D-076) |

### Minijuegos de habilidad
- **Arreo (caballos):** una aguja va y viene; ESPACIO en lo verde = acelerón (perfecto en lo verde claro, más fuerte y duradero); fuera = el caballo se asusta. La carrera se simula en directo.
- **Penalti (fútbol):** la mirilla recorre la portería; el portero tapa un tercio al azar. Pegado al palo entra siempre; fuera de los palos es fuera.
- **Presión (fútbol):** el partido tiene momento; quien aprieta tiene más opciones de gol durante unos minutos. Entrar o cobrar en el momento justo es la habilidad.
- **Venta en directo (fútbol):** un ticket abierto se puede vender antes del final. Su valor sigue la cuota actual (`apuesta × cuota capturada ÷ cuota actual`); al mejorar el resultado se vende con beneficio y al empeorar, con pérdida. El Búho Nv2 elimina la comisión del 10 %.
- **Billar "Tiro imposible" (Tino):** una serie son 3 mesas preparadas de su nivel, cada una con una misión: tronera marcada, a banda (la blanca toca banda antes que ninguna bola), carambola (tocar primero otra bola), sin tocar la negra. Un tiro por mesa; con 2 aciertos ganas la apuesta. Se apunta con el ratón y se afina con ← →; se mantiene el clic para cargar la potencia (sube y baja) y se suelta. **Guía de trayectoria tipo móvil (T25):** una línea de puntos con el recorrido real (misma física que el tiro, con la potencia que cargas) de la blanca y de la primera bola que mueve. **De base es corta** (C06, review 03): la blanca hasta su primer choque y solo la salida de la bola tocada; la **Tiza** suma un rebote y sigue a la bola tocada; la corazonada **Pulso firme** enseña el tiro entero. Tino juega **3 series por noche** (D-075). Física propia y determinista: cada mesa tiene solución comprobada (`tools/dev/billar_solver.gd`).
- **Cartas:** siempre se ve el historial de la mano. Con el Chencho borracho las cuotas ignoran las cartas ya salidas. ESC o `SALIR DE LA MANO` permite abandonar tras confirmar: se pierde el bote y la apuesta ya pagada cuenta como derrota; el reloj vuelve a correr al regresar al bar.

## La barra de Lucía (tienda)

Rondas para subir de nivel, 3 objetos rotativos (cada 90 min o 5 €, máx. 5 en inventario) y chupito de orujo (15 € → +1 suerte).

## Objetos (todos de habilidad o información)

| Objeto | € | Efecto |
|---|---|---|
| Tiza azul | 20 | En el billar, la guía muestra la salida de la bola tocada y el rebote en banda |
| Taco de nácar | 25 | La barra de potencia del billar sube más despacio |
| Guante de billar | 20 | Las flechas afinan la puntería cuatro veces más |
| Bola de la suerte | 30 | Una vez por serie de billar repites un tiro fallado |
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

- Billar: pulso firme, ves el recorrido completo de la blanca y de las bolas para el tiro actual (con un golpe al 80 %).
- Caballos: el siguiente arreo sale perfecto.
- Penalti: el portero se tira al lado contrario.
- Cartas: ves la siguiente carta.

## Combos pensados

- **Leer el partido:** Búho Nv2 + Prismáticos. Apuesta en directo cuando un equipo aprieta y la cuota aún no se ha movido; cobra sin comisión cuando cambie el viento. En Nv3, penalti + Silbato.
- **El tapado:** Gafas + Fusta + Cortado Nv3. Elige el caballo en forma que la casa paga largo y arréale bien.
- **El contador:** Chencho Nv3 + Chuleta (+ Moneda). Cuenta las cartas contra un borracho que paga como si la baraja estuviera entera.
- **Ajuste de cuentas:** Tiza + Taco + Guante (+ pulso firme y Bola de la suerte) para sacar los imposibles de Tino Nv3 y quitarte 100 € de deuda.

## Calibración comprobada

- Equilibrio de la noche y valor esperado de cada actividad: [`BALANCE.md`](BALANCE.md). El caballo "en forma" lleva +3–5 de nota oculta.

- Billar: ventana de ángulo con solución (sumando todas las soluciones, 5 potencias, paso 0,25°): Nv1 2,0–2,75° · Nv2 1,0–2,0° · Nv3 1,0–2,0°. Las misiones de Nv3 suelen tener una sola línea limpia; las demás soluciones son rebotes de suerte.

- Caballos: apostando a todos por igual se recupera ~91 % (margen de la casa); el favorito gana ~43 %. Las carreras duran ~8 minutos de reloj (~14 s reales a x1).
- Dos noches con apuestas aleatorias: terminan con 181 € y 2 € (sin dinero fácil).

## Código

Mapa completo en [`docs/ARCHITECTURE.md`](../ARCHITECTURE.md). Pruebas: `tools/run_tests.sh` / `tools/run_tests.ps1`.

## Ajustes rápidos de equilibrio

- Deuda, dinero inicial, duración, horarios de fútbol: constantes al principio de `game/night/night_state.gd`.
- Carreras (horario, velocidad, `SPEED_K`, margen): `game/night/horse_races.gd`.
- Cuotas de fútbol (margen, cierre, comisión de cobro): `game/night/football_market.gd`.
- Niveles, precios de rondas, objetos, racha: `game/night/catalog.gd`.
- Minijuegos: `game/ui/minigames/billar.gd` (mesas en `game/data/billiard_layouts.gd`, física en `game/simulation/billiard_sim.gd`), `penalty_overlay.gd` (`SPEED`), `game/ui/screens/race_screen.gd` (aguja del arreo).
