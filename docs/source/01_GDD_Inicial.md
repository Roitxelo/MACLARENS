# McLarens: La última combinada
## Documento 01 — GDD inicial y lluvia de sistemas

**Estado:** borrador de diseño v0.1  
**Objetivo:** definir el bucle de juego, los escenarios interactivos, las mecánicas y el alcance inicial.

---

## 1. Género y formato

- Roguelite estratégico.
- Gestión de información y riesgo.
- Simulación deportiva abstracta.
- Interfaz diegética 2D.
- Partidas inicialmente estimadas en 20–40 minutos.
- Experiencia para un jugador.

---

## 2. Bucle principal de una run

1. Aparecen nuevos encuentros y mercados.
2. El jugador revisa cuotas y oportunidades.
3. Consulta fuentes limitadas por tiempo, dinero o acceso.
4. Contrasta datos y formula hipótesis.
5. Crea apuestas simples o combinadas.
6. Los encuentros comienzan y se muestran simultáneamente.
7. Las probabilidades y cuotas cambian en directo.
8. El jugador reacciona mediante cobros, coberturas, nuevos datos o contactos.
9. Se resuelven las apuestas.
10. Obtiene dinero, reputación, herramientas o desbloqueos.
11. Avanza la noche y aumenta la presión.
12. La run termina en la última combinada o en bancarrota.

---

## 3. Recursos principales

### Dinero

Se utiliza para:

- realizar apuestas;
- comprar datos;
- pagar contactos;
- mejorar herramientas durante una run;
- cubrir apuestas;
- aceptar oportunidades especiales.

### Tiempo

Representa el avance de la noche y el tiempo disponible antes de cada encuentro.

Acciones que consumen tiempo:

- leer análisis;
- comparar fuentes;
- hablar con clientes;
- revisar estadísticas;
- investigar perfiles;
- solucionar problemas técnicos.

### Credibilidad

Determina:

- calidad de los contactos;
- acceso a grupos privados;
- precio de la información;
- confianza de otros personajes;
- posibilidad de recibir filtraciones;
- aparición del ojeador.

### Atención

Recurso opcional para controlar la saturación.

Aunque todos los partidos se ven a la vez, ciertas acciones requieren enfocar un encuentro:

- leer estadísticas avanzadas;
- detectar cambios tácticos;
- acceder a mercados instantáneos;
- interpretar eventos ambiguos.

No impide ver los demás marcadores y eventos importantes.

---

## 4. Centro de control

La pantalla principal representa el bar y distribuye información en varias zonas.

### Televisiones

Muestran todos los encuentros activos.

Cada panel incluye:

- deporte;
- participantes;
- marcador;
- tiempo o ronda;
- animación mínima;
- eventos recientes;
- acceso a estadísticas en directo;
- mercados disponibles.

### Máquina de apuestas

Permite:

- explorar mercados;
- crear boletos;
- consultar cuotas;
- confirmar apuestas;
- imprimir tickets;
- gestionar apuestas activas;
- cerrar o cubrir posiciones.

### Ordenador

Permite acceder a:

- estadísticas;
- noticias;
- comparadores de cuotas;
- foros;
- correo;
- retransmisiones secundarias.

### Móvil

Contiene:

- Telegram;
- contactos;
- bots;
- alertas;
- favores;
- oportunidades temporales.

### Mesa

Muestra:

- dinero;
- tickets;
- objetos;
- notas;
- bebida;
- inventario;
- deudas;
- efectos activos.

---

## 5. Deportes iniciales

### 5.1 Fútbol

Variables base:

- ataque;
- defensa;
- forma;
- fatiga;
- disciplina;
- moral;
- portero;
- localía.

Eventos:

- gol;
- tarjeta;
- penalti;
- lesión;
- sustitución;
- córner;
- revisión;
- interrupción;
- tiempo añadido.

Estadísticas en directo:

- posesión;
- tiros;
- tiros a puerta;
- faltas;
- tarjetas;
- córneres;
- peligro ofensivo;
- fatiga aproximada.

### 5.2 Tenis

Variables base:

- servicio;
- resto;
- resistencia;
- confianza;
- superficie;
- molestias;
- presión.

Eventos:

- ace;
- doble falta;
- rotura;
- punto de partido;
- atención médica;
- discusión;
- abandono;
- lluvia.

Estadísticas:

- primeros servicios;
- puntos ganados al saque;
- errores;
- aces;
- dobles faltas;
- break points;
- energía.

### 5.3 Boxeo

Variables base:

- potencia;
- defensa;
- resistencia;
- velocidad;
- precisión;
- daño acumulado;
- estilo.

Eventos:

- golpe limpio;
- caída;
- corte;
- advertencia;
- punto descontado;
- abrazo;
- campana;
- abandono;
- KO.

Estadísticas:

- golpes lanzados;
- golpes conectados;
- daño;
- resistencia;
- puntuación estimada;
- cortes;
- caídas.

---

## 6. Modelo de simulación

Cada participante tiene estadísticas base y modificadores.

La simulación avanza mediante intervalos discretos.

En cada intervalo:

1. se actualiza el estado;
2. se calculan probabilidades de eventos;
3. se selecciona un evento posible;
4. se actualizan marcador y estadísticas;
5. se recalculan mercados y cuotas;
6. se informa al jugador.

Los eventos no se seleccionan con igualdad de probabilidad. Dependen de:

- estadísticas;
- deporte;
- estado actual;
- condiciones;
- eventos anteriores;
- fatiga;
- información oculta;
- modificadores especiales.

---

## 7. Información y fuentes

Cada dato posee:

- contenido;
- fuente;
- fiabilidad real;
- antigüedad;
- especialidad;
- posible sesgo;
- relación con otros datos.

El jugador no ve inicialmente la fiabilidad real.

### Niveles de confirmación sugeridos

- rumor;
- indicio;
- información apoyada;
- información contrastada;
- dato oficial.

Estos niveles no representan certeza absoluta. Representan calidad de evidencia.

### Contradicciones

Cuando dos fuentes se contradicen, el jugador puede:

- ignorar ambas;
- buscar una tercera;
- analizar su historial;
- pagar una verificación;
- apostar aprovechando la incertidumbre;
- esperar, arriesgándose a que la cuota cambie.

---

## 8. Webs del ordenador

### StatZone

Estadísticas históricas y análisis.

Mejoras:

- filtros avanzados;
- comparación;
- tendencias;
- árbitros;
- superficies;
- estilos;
- alertas de anomalías.

### Diario Gol Local

Noticias y periodistas con reputaciones diferentes.

### ForoBet

Usuarios con historial, especialidad, sesgo y comportamiento.

### CuotaCompare

Evolución de cuotas y movimientos anómalos.

### StreamPirata

Permite seguir encuentros secundarios, con retraso o fallos.

### Correo

Promociones, filtraciones, amenazas, facturas y accesos.

---

## 9. Telegram

### Tipos

- canales públicos;
- grupos privados;
- bots;
- contactos personales;
- chats de pago;
- grupos de apuestas colectivas.

### Acciones

- comprar información;
- pedir confirmación;
- compartir un dato;
- aceptar un favor;
- denunciar una fuente;
- bloquear;
- negociar;
- seguir una alerta;
- contratar una intervención.

### Ejemplos

- McLarens Insider;
- Cuotas Caídas;
- Verde Siempre;
- Árbitros y Tarjetas;
- Segunda División Profunda;
- La Trastienda.

---

## 10. Máquina de apuestas

### Mercados comunes

- ganador;
- empate;
- doble oportunidad;
- goles o puntos;
- tarjetas;
- córneres;
- resultado por fases;
- goleador;
- KO;
- abandono;
- número de sets o rondas.

### Mercados en directo

Se abren y cierran según el estado.

### Mercados especiales temporales

Aparecen durante pocos segundos cuando se cumplen condiciones.

Ejemplos:

- invasión de campo;
- espontáneo desnudo;
- pelea;
- lesión del árbitro;
- rotura de equipamiento;
- entrada de un animal;
- apagón;
- suspensión;
- abandono.

### Apuestas cruzadas

Relacionan varios encuentros.

Ejemplo:

- “Habrá un gol en el partido A antes de que termine el tercer asalto del combate B.”

---

## 11. Construcción de apuestas

Una apuesta contiene:

- capital arriesgado;
- selecciones;
- cuota inicial;
- cuota actual;
- probabilidad estimada por la casa;
- información relacionada;
- posibles coberturas;
- estado.

### Combinadas

Añadir selecciones incrementa la cuota, pero multiplica los puntos de fallo.

Las selecciones pueden:

- reforzarse;
- contradecirse;
- depender del mismo evento;
- pertenecer a deportes diferentes;
- desbloquear bonos especiales.

### Sinergias

Ejemplo:

- árbitro tarjetero;
- derbi;
- lluvia;
- equipo agresivo;
- mercado de tarjetas.

La apuesta no recibe una garantía, sino una mejor fundamentación.

---

## 12. Acciones en directo

### Cobro anticipado

Convierte la apuesta activa en una cantidad segura.

### Cobertura

Abre una posición contraria para reducir pérdidas.

### Venta parcial

Elimina parte de la apuesta o una selección.

### Cambio a mercado seguro

Reduce la cuota y flexibiliza la condición.

### Congelar cuota

Reserva temporalmente una cuota antes de confirmar.

### Seguro

Una selección fallida se anula bajo determinadas condiciones.

### Auditoría

Investiga una fuente después de una contradicción.

### Alerta

Notifica cambios relevantes en un encuentro.

---

## 13. Contactos del bar

### Borracho contratado

Puede ser pagado para intentar aparecer en un encuentro.

Parámetros:

- fiabilidad;
- coste;
- acceso;
- discreción;
- nivel de caos;
- riesgo de detención.

Resultados posibles:

- invade el campo;
- provoca una interrupción;
- añade tiempo;
- genera una pelea;
- altera la concentración;
- fracasa;
- llega al partido equivocado;
- causa una suspensión.

### Camarero

Escucha rumores y gestiona recursos del bar.

### Dueño

Controla acceso, deudas y cierre.

### Exjugador

Interpreta estado físico y tácticas.

### Estadístico

Mejora análisis numérico.

### Periodista

Obtiene noticias y alineaciones.

### Árbitro retirado

Analiza disciplina y decisiones.

### Hacker

Detecta movimientos de mercado o información digital.

### Rival

Compite por la misma información y puede provocar movimientos de cuota.

---

## 14. Eventos del bar

- caída de internet;
- máquina sin papel;
- bebida sobre el ordenador;
- batería baja;
- apagón;
- pelea;
- policía;
- cierre anticipado;
- porra colectiva;
- cambio de canal;
- llegada de un contacto;
- compra de un ticket por otro cliente;
- impresión de un boleto ajeno;
- mensaje enviado por error;
- promoción limitada;
- ojeador observando.

---

## 15. Evolución de la casa

La casa aprende patrones generales de la run.

Puede:

- reducir cuotas explotadas;
- aplicar comisiones;
- cerrar mercados;
- presentar apuestas tentadoras;
- ofrecer promociones personalizadas;
- introducir información engañosa;
- aumentar la velocidad de actualización.

La casa no debe alterar retroactivamente resultados ni hacer trampas invisibles.

---

## 16. Progresión entre runs

Completar runs y desafíos desbloquea:

- nuevos deportes;
- equipos;
- fuentes;
- contactos;
- mercados;
- eventos;
- webs;
- herramientas;
- objetos;
- personajes;
- dificultades;
- escenarios.

Ejemplos de hitos:

- completar tres runs;
- alcanzar una fortuna concreta;
- maxear herramientas;
- acertar una apuesta especial;
- completar una run sin préstamos;
- ganar usando tres deportes;
- detectar cinco informaciones falsas;
- contratar con éxito al borracho varias veces.

---

## 17. El ojeador y el megacasino

El ojeador aparece tras cumplir un requisito de prestigio.

Presentación:

- hombre trajeado;
- habla poco;
- ha observado las decisiones del jugador;
- ofrece una invitación o ficha especial.

El megacasino incluye:

- más encuentros simultáneos;
- pantallas configurables;
- mercados VIP;
- deportes adicionales;
- contactos internacionales;
- torneos;
- reglas de la casa más agresivas;
- competidores;
- apuestas cruzadas complejas.

Debe funcionar como expansión de la misma fantasía, no como un juego diferente.

---

## 18. Objetivo de una run

Propuesta inicial:

- comenzar con una cantidad limitada;
- superar varios umbrales durante la noche;
- llegar al cierre con el capital requerido;
- completar una última combinada especial.

Estados de derrota:

- perder todo el capital sin acceso a crédito;
- superar la deuda máxima;
- agotar el tiempo;
- perder acceso a la máquina;
- fallar una condición especial de la run.

---

## 19. Alcance recomendado para el primer prototipo

### Implementar

- un solo escenario: bar;
- centro de control;
- dos o tres televisiones;
- fútbol como único deporte inicial;
- cuatro equipos;
- simulación por intervalos;
- seis mercados;
- apuestas simples y combinadas;
- cobro anticipado;
- estadísticas en directo;
- una web de estadísticas;
- Telegram con tres contactos;
- un evento especial temporal;
- el borracho como intervención;
- tres jornadas y una final.

### No implementar todavía

- megacasino jugable;
- tenis y boxeo completos;
- relaciones complejas;
- decenas de webs;
- campañas narrativas;
- multijugador;
- datos reales;
- animación deportiva detallada.

---

## 20. Preguntas de diseño pendientes

1. ¿Las cuotas muestran una estimación exacta o una valoración simplificada?
2. ¿Qué información conoce la casa y cuándo la incorpora?
3. ¿Cuánto dura un intervalo de simulación?
4. ¿El tiempo se pausa al usar algunos dispositivos?
5. ¿Cómo se representa la calidad de una fuente sin mostrar porcentajes exactos?
6. ¿Qué provoca el final de una jornada?
7. ¿Qué ocurre si varios encuentros generan eventos simultáneos?
8. ¿Cuántos partidos son legibles a la vez?
9. ¿Cómo se evita que investigar sea siempre mejor que apostar rápido?
10. ¿Qué desbloqueos cambian realmente el estilo de juego?

---

## 21. Hipótesis de diversión a validar

El primer prototipo debe demostrar estas hipótesis:

1. Consultar y contrastar información es divertido.
2. Ver varios encuentros simultáneos genera tensión sin resultar ilegible.
3. Las estadísticas en directo permiten tomar decisiones comprensibles.
4. Cobrar, cubrir o mantener crea decisiones difíciles.
5. Los eventos absurdos producen momentos memorables.
6. El jugador siente que obtiene una ventaja, aunque el resultado siga siendo incierto.
7. Una run ofrece suficiente variación con pocos equipos y mercados.

---

## 22. Definición del prototipo exitoso

El prototipo será exitoso si un jugador puede:

- revisar tres partidos;
- descubrir información contradictoria;
- decidir qué fuente creer;
- construir una apuesta;
- ver los partidos evolucionar;
- reaccionar a un cambio;
- utilizar al borracho;
- aceptar o rechazar un cobro anticipado;
- terminar una run corta;
- comprender por qué ganó o perdió.
