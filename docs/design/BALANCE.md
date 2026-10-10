# Equilibrio (T05)

> Herramienta: `tools/dev/balance_sim.gd` juega noches completas con bots usando las reglas reales (`night_state`, mercados, carreras, catálogo). Los minijuegos de habilidad se modelan con probabilidades declaradas.
>
> ```bash
> # noches completas: [noches] [deuda]       (BAL_START=150 cambia el dinero inicial, BAL_PROF=habil un solo perfil, BAL_DEBUG=1 imprime la noche)
> godot --headless --path game -s res://../tools/dev/balance_sim.gd -- 300 500
> # valor esperado por actividad: [pruebas] [deuda] ev [h=caballos c=cartas f=fútbol]
> godot --headless --path game -s res://../tools/dev/balance_sim.gd -- 300 500 ev hcf
> ```

Medido el 10/10/2026 sobre el commit que añade este documento.

## Perfiles de jugador (supuestos del modelo)

| Perfil | Arreo (perfecto / bueno / fallo) | Billar: acierto por tiro Nv1 / Nv2 / Nv3 | Cartas | Estilo |
|---|---|---|---|---|
| azar | 5 % / 15 % / 80 % | 30 % / 15 % / 6 % | mira solo la carta actual | apuesta a lo que sea, no compra |
| normal | 15 % / 35 % / 50 % | 55 % / 35 % / 18 % | mira solo la carta actual | solo apuesta con ventaja, compra poco |
| hábil | 30 % / 40 % / 30 % | 80 % / 60 % / 40 % | cuenta cartas | apuesta con ventaja y tamaño de apuesta ~40 % en el billar |

Las mesas del billar son fijas, así que un jugador que repite noches **aprende** los tiros: su acierto real sube con la práctica (el modelo no lo tiene en cuenta).

## Valor esperado por actividad (beneficio por € apostado)

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

## Resultado de la noche (300 noches por perfil, 100 € iniciales)

| Deuda | azar | normal | hábil |
|---|---|---|---|
| 250 € | 1 % | 0 % | 29 % |
| 300 € | 1 % | 0 % | 24 % |
| 400 € | 0 % | 0 % | 19 % |
| **500 € (actual)** | **0 %** | **0 %** | **15 %** |
| 500 € con 150 € iniciales | 0 % | 0 % | 22 % |
| 500 € con 200 € iniciales | 0 % | 2 % | 30 % |

Mediana del hábil con 500 €: 78 € al cierre; p90: 595 €. La noche es **muy de todo o nada**: el que sube la escalera del billar paga holgado; el resto se queda corto.

## Cambios aplicados en este pase

- **Caballo en forma**: +3–5 de nota (antes +14–22). Con las Gafas era una mina: EV +3 a +6 por € incluso jugando al azar.
- **Momento del fútbol** más persistente (0,88) y con más efecto (±65 % de ataque): leer la presión pasa de no servir a dar una ventaja pequeña.
- **Billar**: Tino paga **1:1, 2:1 y 3:1** según el nivel, y eliges la apuesta (10 € hasta 50 / 100 / 150 €). Antes era 1:1 fijo de 20/40/60 € y no daba para remontar.

## Decisión de Roi (10/10/2026): opciones 2 + 3

El objetivo de T05 era "azar < 15 %, hábil 50-70 %". Lo primero se cumple de sobra; lo segundo no (15 %). Opciones, de menos a más cambio:

1. **Bajar la deuda a 300 €** (hábil ~24 %, azar ~1 %). Mantiene la tensión.
2. **Empezar con 200 €** y mantener 500 € (hábil ~30 %): más margen para comprar mejoras pronto.
3. **Más ventaja para la habilidad**: arreo perfecto un poco más fuerte, Chencho Nv3 que no baraja entre manos (contar cartas daría ventaja real; ahora no la da) y un segundo partido con más presión.
4. Asumir que el modelo es pesimista (un jugador que repite aprende las mesas del billar) y **probarlo con jugadores** antes de tocar la deuda.

Roi confirma **2 + 3**: empezar con 200 €, reforzar el arreo perfecto, hacer persistente la baraja de Chencho Nv3 y dar al segundo partido una presión más marcada. Falta repetir la simulación y validar la sensación en el playtest de T01.

### Validación tras aplicar 2 + 3

300 noches por perfil, deuda de 500 € y 200 € iniciales:

| Perfil | Paga a Tino | Mediana | p10 | p90 |
|---|---:|---:|---:|---:|
| azar | 0,3 % | 43 € | 14 € | 150 € |
| normal | 2,0 % | 90 € | 43 € | 189 € |
| hábil | **33,7 %** | 186 € | 18 € | 1.327 € |

La tasa hábil mejora del 15 % al 33,7 %, pero todavía no alcanza el objetivo del 50–70 %. T05 continúa en curso hasta contrastar el modelo con T01; no se sube más la ventaja sin jugarlo, porque el p90 ya muestra noches de premio muy alto.
