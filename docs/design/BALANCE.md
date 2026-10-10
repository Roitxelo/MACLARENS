# Equilibrio

> Herramientas (todas juegan con las reglas reales):
>
> ```bash
> # campañas de 5 noches: [campañas] camp   (BAL_START=200, BAL_QUOTAS="100,150,300,500,750", BAL_PROF=habil, BAL_DEBUG=1)
> godot --headless --path game -s res://../tools/dev/balance_sim.gd -- 300 camp
> # valor esperado del fútbol antes del partido y en directo (por minuto, marcador y presión)
> godot --headless --path game -s res://../tools/dev/football_ev.gd -- 3000
> godot --headless --path game -s res://../tools/dev/football_live_ev.gd -- 3000
> ```

## Campaña de 5 noches (T26, 10/10/2026) — estado actual

**Reglas:** 200 € iniciales; Tino cobra 100 / 150 / 300 / 500 / 750 € al cierre de cada noche; se conservan dinero, niveles y objetos. Boleto máximo de 50 €, cuota hípica máxima 15. Billar: 1:1 / 3:2 / 2:1, hasta 30 / 60 / 100 €, 3 series por noche, con guía de trayectoria.

**Supuesto nuevo del billar con la guía (acierto por tiro Nv1/Nv2/Nv3):** azar 50/30/15 %, normal 75/50/30 %, hábil 90/70/50 %. Hay que confirmarlo jugando.

Porcentaje de campañas que **superan** cada noche (300 campañas por perfil):

| Perfil | N1 | N2 | N3 | N4 | N5 (gana) |
|---|---|---|---|---|---|
| azar | 62 % | 5 % | 0 % | 0 % | 0 % |
| normal | 48 % | 7 % | 2 % | 1 % | 0 % |
| hábil | 76 % | 55 % | 45 % | 41 % | **37 %** |

Otras escaleras probadas (hábil gana la campaña): 150/200/300/400/500 con 100 € → 25 %; 100/200/350/550/800 con 200 € → 32 %; 80/150/250/400/600 con 200 € → 43 %.

**Lo que se aprendió:**

- **Bola de nieve.** Sin topes, el hábil que sobrevivía a la noche 2 acababa con 3.000-5.000 €: Tino a 2:1 y 3:1 con 150 € varias veces por noche, y tapados a 40 con soplo, arreos y racha (+2.000 € en una carrera). Con los topes (D-074, D-075) el crecimiento es lineal, de unos 500-900 € por noche con todo comprado, y las cuotas finales siguen exigiendo jugar bien.
- **Las noches 1-2 son el embudo.** Ahí se compran las mejoras; el bot hábil cae si se las gasta todas. Un jugador que guarda la cuota pasa mucho más (el bot ya reserva la cuota en las últimas horas).
- **Fútbol sin trampa fija.** A cuota de salida ninguna apuesta gana (de −16 % a 0 %). En directo, leer la presión sí da ventaja (por ejemplo, minuto 45-60, empate y presión del visitante: apostar al visitante da +0,2 a +0,3 por €). Es la habilidad buscada. Lo que Roi explotaba era que **todas las noches eran iguales**; ahora cambian horas y cruces.
- **El modelo es pesimista con el jugador medio:** pierde dinero en casi todo salvo el billar Nv1. Si en el playtest los jugadores normales no pasan de la noche 2, la palanca es la cuota de la noche 2 (150 → 120) o el billar Nv1.

### Guía corta del billar (C06, review 03)

Roi encontró el billar "excesivamente fácil" con la guía larga. Con la guía corta, el acierto estimado por tiro pasa a: azar 40/20/10 %, normal 65/42/24 %, hábil 85/65/45 % (la Tiza suma 8 puntos). Campaña (300 por perfil): **hábil gana el 20 %** (antes 37 %), normal y azar 0 %. Roi dice que el nivel general "está bien en principio", así que no se tocan las cuotas hasta su próxima partida.

### Estrategias deportivas fijas (C01, H0)

`tools/dev/fixed_strategies.gd -- 300`: el bot repite lo mismo todas las noches (25 % de la banca, máx. 50 €), sin minijuegos ni compras.

| Estrategia | Supera N1 | N2 | N3 | Gana | Beneficio por € |
|---|---|---|---|---|---|
| No apostar | 100 % | 0 % | 0 % | 0 % | 0 |
| Siempre el favorito | 100 % | 14 % | 0 % | 0 % | −0,16 |
| Siempre el empate | 100 % | 26 % | 3 % | 0 % | −0,05 |
| Siempre el tapado | 100 % | 29 % | 3 % | 0 % | −0,02 |
| Siempre McLarens FC | 100 % | 19 % | 0 % | 0 % | −0,14 |
| Al que va ganando en el 70' | 100 % | 0 % | 0 % | 0 % | −0,04 |
| Caballo favorito | 68 % | 20 % | 5 % | 0 % | −0,04 |
| Caballo más tapado | 4 % | 1 % | 0 % | 0 % | −0,83 |

**Ninguna estrategia fija gana la campaña.** Hace falta habilidad (presión, arreo, cartas, billar). Dos avisos para Roi:

- **La noche 1 se pasa sin jugar:** 200 € iniciales cubren la cuota de 100 €. Funciona como noche de aprendizaje, pero no aprieta. Si se quiere tensión desde el principio, la cuota de N1 podría subir a 150 o la banca inicial bajar a 120.
- **El tope de 15 a 1** hace que apostar a ciegas al tapado sea ruinoso (−83 %). Es intencionado: un tapado solo compensa con soplo (Gafas) y arreos.

## Histórico: noche única (T05, antes de la campaña)

> Herramienta: `tools/dev/balance_sim.gd` juega noches completas con bots usando las reglas reales (`night_state`, mercados, carreras, catálogo). Los minijuegos de habilidad se modelan con probabilidades declaradas.
>
> ```bash
> # noches completas: [noches] [deuda]       (BAL_START=150 cambia el dinero inicial, BAL_PROF=habil un solo perfil, BAL_DEBUG=1 imprime la noche)
> godot --headless --path game -s res://../tools/dev/balance_sim.gd -- 300 500
> # valor esperado por actividad: [pruebas] [deuda] ev [h=caballos c=cartas f=fútbol]
> godot --headless --path game -s res://../tools/dev/balance_sim.gd -- 300 500 ev hcf
> ```

Medido el 10/10/2026 sobre el commit que añade este documento.

### Perfiles de jugador (supuestos del modelo)

| Perfil | Arreo (perfecto / bueno / fallo) | Billar: acierto por tiro Nv1 / Nv2 / Nv3 | Cartas | Estilo |
|---|---|---|---|---|
| azar | 5 % / 15 % / 80 % | 30 % / 15 % / 6 % | mira solo la carta actual | apuesta a lo que sea, no compra |
| normal | 15 % / 35 % / 50 % | 55 % / 35 % / 18 % | mira solo la carta actual | solo apuesta con ventaja, compra poco |
| hábil | 30 % / 40 % / 30 % | 80 % / 60 % / 40 % | cuenta cartas | apuesta con ventaja y tamaño de apuesta ~40 % en el billar |

Las mesas del billar son fijas, así que un jugador que repite noches **aprende** los tiros: su acierto real sube con la práctica (el modelo no lo tiene en cuenta).

### Valor esperado por actividad (beneficio por € apostado)

| Actividad | azar | normal | hábil |
|---|---|---|---|
| Caballos: favorito, sin arreos | −0,22 | −0,22 | −0,22 |
| Caballos: favorito, Cortado Nv2 | −0,30 | −0,16 | −0,10 |
| Caballos: favorito, Cortado Nv3 + Fusta | −0,38 | −0,13 | **+0,16** |
| Caballos: caballo en forma (Gafas) + Nv3 + Fusta | −0,35 | ≈0 / +0,2 | **+0,8** |
| Fútbol: leer la presión (Búho Nv2, cobra al +60 %) | −0,05 | | **+0,06** |
| Cartas Chencho Nv1 / Nv2 / Nv3 | ≈ −0,05 / +0,05 / +0,05 | | ≈ −0,05 / +0,02 / ≈0 |
| Billar Nv1 (paga 1:1) | −0,57 | +0,15 | **+0,79** |
| Billar Nv2 (paga 2:1) | −0,85 | −0,23 | **+0,94** |
| Billar Nv3 (paga 3:1) + 100 € de deuda la 1.ª vez | −0,97 | −0,63 | **+0,41** |

(El billar es analítico: P(2 de 3) con el acierto del perfil.)

### Resultado de la noche (300 noches por perfil, 100 € iniciales)

| Deuda | azar | normal | hábil |
|---|---|---|---|
| 250 € | 1 % | 0 % | 29 % |
| 300 € | 1 % | 0 % | 24 % |
| 400 € | 0 % | 0 % | 19 % |
| **500 € (actual)** | **0 %** | **0 %** | **15 %** |
| 500 € con 150 € iniciales | 0 % | 0 % | 22 % |
| 500 € con 200 € iniciales | 0 % | 2 % | 30 % |

Mediana del hábil con 500 €: 78 € al cierre; p90: 595 €. La noche es **muy de todo o nada**: el que sube la escalera del billar paga holgado; el resto se queda corto.

### Cambios aplicados en este pase

- **Caballo en forma**: +3–5 de nota (antes +14–22). Con las Gafas era una mina: EV +3 a +6 por € incluso jugando al azar.
- **Momento del fútbol** más persistente (0,88) y con más efecto (±65 % de ataque): leer la presión pasa de no servir a dar una ventaja pequeña.
- **Billar**: Tino paga **1:1, 2:1 y 3:1** según el nivel, y eliges la apuesta (10 € hasta 50 / 100 / 150 €). Antes era 1:1 fijo de 20/40/60 € y no daba para remontar.

### Decisión de Roi (10/10/2026): opciones 2 + 3

El objetivo de T05 era "azar < 15 %, hábil 50-70 %". Lo primero se cumple de sobra; lo segundo no (15 %). Opciones, de menos a más cambio:

1. **Bajar la deuda a 300 €** (hábil ~24 %, azar ~1 %). Mantiene la tensión.
2. **Empezar con 200 €** y mantener 500 € (hábil ~30 %): más margen para comprar mejoras pronto.
3. **Más ventaja para la habilidad**: arreo perfecto un poco más fuerte, Chencho Nv3 que no baraja entre manos (contar cartas daría ventaja real; ahora no la da) y un segundo partido con más presión.
4. Asumir que el modelo es pesimista (un jugador que repite aprende las mesas del billar) y **probarlo con jugadores** antes de tocar la deuda.

Roi confirma **2 + 3**: empezar con 200 €, reforzar el arreo perfecto, hacer persistente la baraja de Chencho Nv3 y dar al segundo partido una presión más marcada. Falta repetir la simulación y validar la sensación en el playtest de T01.

#### Validación tras aplicar 2 + 3

300 noches por perfil, deuda de 500 € y 200 € iniciales:

| Perfil | Paga a Tino | Mediana | p10 | p90 |
|---|---:|---:|---:|---:|
| azar | 0,3 % | 43 € | 14 € | 150 € |
| normal | 2,0 % | 90 € | 43 € | 189 € |
| hábil | **33,7 %** | 186 € | 18 € | 1.327 € |

La tasa hábil mejora del 15 % al 33,7 %, pero todavía no alcanza el objetivo del 50–70 %. T05 continúa en curso hasta contrastar el modelo con T01; no se sube más la ventaja sin jugarlo, porque el p90 ya muestra noches de premio muy alto.
