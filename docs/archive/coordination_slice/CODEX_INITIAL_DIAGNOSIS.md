# Diagnóstico inicial independiente de Codex

## 1. Síntesis del juego

**McLarens: La última combinada** es un roguelite estratégico de información y riesgo ambientado en un bar nocturno. El jugador observa encuentros ficticios, consulta fuentes imperfectas, detecta discrepancias entre la probabilidad real y la cuota de la casa, construye apuestas y modifica su exposición mientras los partidos evolucionan.

La apuesta es el vehículo; el juego real consiste en **interpretar información incompleta antes de que pierda valor**.

## 2. Fantasía y core loop

La fantasía es ser la persona más despierta del bar: alguien capaz de conectar un rumor, una estadística y un movimiento de cuota antes que la casa.

Core loop entendido:

1. Aparece una oportunidad.
2. El jugador inspecciona cuotas y encuentros.
3. Consume tiempo para consultar fuentes.
4. Contrasta información contradictoria.
5. Formula una hipótesis.
6. Apuesta capital sobre ella.
7. Observa cómo evolucionan simultáneamente los encuentros.
8. Mantiene, cobra o cubre su posición ante nueva información.
9. Comprueba si su razonamiento produjo una ventaja, aunque el resultado pueda fallar.
10. Avanza hacia una combinada final o la bancarrota.

El placer principal debería venir del momento «lo vi antes», no únicamente de una cifra de ganancias.

## 3. Qué debe funcionar en el primer minuto

- Dos encuentros visibles y claramente diferenciados.
- Una cuota comprensible que parezca normal.
- Un mensaje que revele una posible anomalía.
- Una segunda fuente que contradiga o matice el mensaje.
- Una decisión inmediata: investigar más o aprovechar la cuota.
- La posibilidad de realizar una apuesta sin navegar por menús complejos.
- El comienzo visible del encuentro.
- Un evento que cambie la lectura de la apuesta.
- Una primera elección entre mantener o aceptar un cobro reducido.

Al acabar ese minuto, el jugador debe entender: **la información cuesta tiempo, las cuotas caducan y tener razón no garantiza ganar**.

## 4. Pilares no negociables

- Información incompleta y fuentes potencialmente contradictorias.
- Probabilidades dinámicas, nunca resultados completamente predeterminados.
- Ventaja informativa temporal frente a la casa.
- Decisiones de riesgo durante el encuentro, no solo antes de empezar.
- Varios encuentros visibles simultáneamente.
- Interfaz integrada físicamente en el bar.
- Claridad causal suficiente para comprender por qué cambió una probabilidad.
- Tensión combinada con humor local y absurdo deportivo.
- Universo completamente ficticio.
- La información aumenta conocimiento, pero nunca concede certeza.
- No glorificar perseguir pérdidas.
- Progresión futura mediante nuevas posibilidades, no solo mejoras numéricas.

La progresión roguelite completa es parte de la visión, pero no necesita estar implementada para validar el primer prototipo.

## 5. MVP técnicamente viable para la jam

Una run de 8–12 minutos con:

- Un único escenario: McLarens.
- Fútbol como único deporte.
- Dos partidos simultáneos; un tercero solo en la combinada final si el rendimiento lo permite.
- Cuatro equipos ficticios.
- Simulación por intervalos.
- Tres mercados: ganador, goles y tarjetas.
- Apuestas simples y combinadas de dos selecciones.
- Una web de estadísticas muy reducida.
- Un móvil con tres fuentes de perfiles reconocibles.
- Un caso de información contradictoria por jornada.
- Apostar, mantener y cobrar anticipadamente.
- Una intervención del borracho con varios resultados probabilísticos.
- Dos jornadas breves y una combinada final.
- Un resumen final que explique la información conocida, lo ocurrido y el resultado económico.

La casa puede actualizar cuotas según el estado y según un dato que llega tarde. No necesita todavía aprender cómo juega el usuario.

## 6. Recortes obligatorios

- Tenis y boxeo.
- Megacasino y ojeador jugables.
- Metaprogresión persistente compleja.
- Coberturas, venta parcial, seguros y mercados cruzados.
- Atención como recurso separado.
- Credibilidad como sistema numérico completo.
- Navegador libre con múltiples webs.
- Relaciones y evolución de contactos.
- IA adaptativa de la casa.
- Simulación visual detallada del fútbol.
- Inventario, deudas, préstamos y mejoras de herramientas.
- Eventos extensos del bar.
- Decenas de mercados y estadísticas.
- Generación procedural generalista.
- Tutorial independiente.

El borracho sí permanecería porque condensa tono, intervención sistémica y probabilidad sin garantía.

## 7. Principales riesgos técnicos

1. **Legibilidad:** dos partidos, mensajes, cuotas y eventos pueden saturar incluso antes de llegar a tres pantallas.
2. **Modelo probabilístico opaco:** si el jugador no entiende qué influyó en una cuota, los resultados parecerán arbitrarios.
3. **Desacoplar verdad, conocimiento y precio:** el estado real, lo que sabe el jugador y lo que sabe la casa deben poder diferir sin contradecirse accidentalmente.
4. **Economía degenerada:** una estrategia obvia podría dominar o la varianza podría borrar toda sensación de habilidad.
5. **Sincronización temporal:** consultas, caducidad de cuotas, simulación y cobro deben convivir sin producir decisiones imposibles.
6. **Combinadas correlacionadas:** multiplicar cuotas ingenuamente puede romper la economía.
7. **UI diegética demasiado ambiciosa:** intentar representar físicamente cada dispositivo puede retrasar la validación del loop.
8. **Contenido artesanal insuficiente:** las contradicciones solo serán interesantes si tienen contexto y consecuencias comprensibles.
9. **Feedback tardío:** ganar o perder no basta; el juego debe distinguir una buena lectura con mal resultado de una mala lectura afortunada.
10. **Arquitectura prematura:** construir sistemas extensibles para tres deportes antes de validar uno repetiría el error del experimento anterior.

## 8. Primer prototipo construible

Un slice único, sin run completa:

- Dos partidos están próximos a comenzar.
- La casa ofrece cuotas iniciales.
- Telegram afirma que el delantero de un equipo está lesionado.
- La web estadística muestra que entrenó, pero también un descenso reciente de rendimiento.
- Investigar una fuente adicional consume tiempo y puede hacer que la cuota cambie.
- El jugador apuesta o se abstiene.
- Ambos partidos empiezan y avanzan por eventos discretos.
- Llega una confirmación parcial; la casa reajusta la cuota.
- Se ofrece un cobro anticipado.
- El jugador mantiene o cobra.
- El partido se resuelve.
- Una pantalla breve separa calidad de la decisión, resultado deportivo y resultado económico.

Este prototipo valida el corazón del juego sin necesitar progresión, contenido procedural ni una noche completa.

## 9. Arquitectura mínima recomendada

Mantendría cinco límites claros:

- **Estado de encuentro:** participantes, reloj, marcador, estadísticas y modificadores ocultos.
- **Simulación:** genera eventos a partir del estado y de probabilidades ponderadas.
- **Mercado/casa:** calcula probabilidades estimadas, cuotas, disponibilidad y cobro.
- **Información:** contiene hechos, rumores, fuentes, fiabilidad y momento de revelación.
- **Run/presentación:** tiempo, capital, apuestas activas y coordinación de las pantallas del bar.

Regla esencial: una fuente no modifica directamente el partido. Revela o interpreta un hecho. Una intervención como el borracho sí introduce un modificador probabilístico explícito.

Los contenidos —equipos, fuentes, eventos y mercados— deberían estar definidos como datos, no dispersos por la lógica. No diseñaría todavía una arquitectura universal para todos los deportes.

## 10. Qué debería liderar Codex

- Arquitectura mínima y contratos entre módulos.
- Modelo de estado compartido.
- Simulación base del partido.
- Mercado, cuotas, apuestas y cobro anticipado.
- Reloj general y flujo del slice.
- Integración de las interfaces diegéticas.
- Herramientas de diagnóstico de probabilidades.
- Build jugable y pruebas de estabilidad.
- Control de alcance y ownership de archivos.

También garantizaría que cada entrega termine en algo ejecutable y que Claude pueda integrar su módulo sin depender de cambios improvisados en sus archivos.

## 11. Módulo completo que podría liderar Claude

Claude podría ser propietario del **módulo de investigación e información**, tanto en diseño como en implementación:

- Modelo de fuentes y evidencias.
- Generación o selección de rumores.
- Contradicciones y niveles de confirmación.
- Coste temporal de consultas.
- Tres personalidades de fuente.
- Flujo de Telegram y web estadística.
- Relación visible entre evidencia e hipótesis.
- Caso completo de la lesión del delantero.
- Feedback que explique qué señales eran fiables.

Es un sistema central para la diversión, no una tarea auxiliar. Tendría sus propios archivos y una interfaz pactada con el estado del partido y el reloj. Durante una tarea, solo Claude editaría esos archivos; Codex integraría mediante contratos compartidos o archivos de integración bajo su ownership.

## 12. Decisiones del usuario y decisiones reversibles

### Requieren al usuario

- Equilibrio exacto entre tensión estratégica y comedia absurda.
- Cuánto debe parecerse visualmente al escritorio de las referencias.
- Si el jugador puede pausar al cambiar de dispositivo.
- Nivel de cercanía estética y temática con apuestas reales.
- Qué emoción debe dominar la derrota: tragedia, humor o aprendizaje.
- Si el borracho pertenece al primer slice pese a aumentar el alcance.
- Motor y plataforma objetivo, si todavía no están decididos.
- Qué constituye una victoria satisfactoria de la run.

### Podemos decidir de forma reversible

- Duración provisional de los intervalos.
- Valores iniciales de cuotas y capital.
- Dos o tres partidos en pantalla durante pruebas.
- Distribución provisional de paneles.
- Nombres de equipos y fuentes.
- Número inicial de eventos.
- Formato interno de datos.
- Fórmula provisional del cobro anticipado.
- Orden de aparición de mensajes.
- Qué estadísticas se muestran mientras se prueba legibilidad.

## 13. Tres ideas nuevas compatibles con la visión

1. **Sello «la casa aún no lo sabe»:** algunas evidencias muestran indirectamente cuánto tardará la casa en incorporarlas. No revela la verdad; convierte el valor temporal de la información en una decisión visible.
2. **Autopsia de la apuesta:** al resolverla, el ticket señala qué inferencias eran sólidas, qué fuente engañó al jugador y qué parte fue simple varianza. Refuerza que una buena decisión puede perder.
3. **Ruido del bar como información ambiental:** reacciones de clientes y sonido de televisiones pueden anticipar eventos antes de que el panel los formalice. Es una fuente rápida, gratuita y poco fiable que aprovecha la interfaz diegética.

## Propuesta concreta de MVP y reparto inicial

El MVP será una run de fútbol de 8–12 minutos, con dos partidos simultáneos, tres mercados, investigación limitada por tiempo, fuentes contradictorias, apuestas simples y una combinada final, cuotas dinámicas, cobro anticipado y una intervención probabilística del borracho.

- **Codex:** núcleo de simulación, mercado, apuestas, reloj, flujo de run, integración y build.
- **Claude:** módulo completo de investigación e información, incluyendo su diseño jugable, contenido inicial e implementación aislada.
- **Usuario:** decide tono, pausa, dirección visual, experiencia de derrota y si el borracho entra en el primer slice.
- **Ownership:** un único propietario por archivo durante cada tarea; contratos compartidos acordados antes de que cualquiera implemente contra ellos.
