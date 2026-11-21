# Explicaciones teóricas

*A continuación presentamos dónde aplicamos los distintos conceptos que se buscaban en cada entrega.*

## Índice

- [Polimorfismo](#polimorfismo)
- [Herencia](#herencia)
- [Template Method](#template-method)
---

## Polimorfismo

**Puertas:** todas las puertas entienden `puedePasar()` y `mensajeBloqueo()`, y cada una lo resuelve a su manera.
- `puertaAnubis` le pregunta al disfraz del jugador.
- `puertaArtista` pide que el puzzle de marcos esté resuelto, además del disfraz.
- `puertaFinal` pide que las estatuas estén resueltas y que el jugador tenga la llave.

**Disfraces:** `disfrazPolicia`, `disfrazAnubis` y `disfrazArtista` entienden los mensajes `image()`, `desgastar(personaje)`, `permiteAccesoAnubis()` y `permiteAccesoArtista()`. El jugador y las puertas los usan sin preguntar cual es cual.

**Visuales:** se le manda el mensaje `chocarConJugador()` a cualquier cosa con la que choque el jugador (puertas, llave, activadores de disfraz, estatuas, marcos, etc.) y cada una hace lo suyo.

**Estados de las estatuas:** `EstadoNeutral` `EstadoVerdad` `EstadoFalso` entienden `coincideCon(diceLaVerdad)`, cada estado sabe evaluar si coincide con la estatua y como dibujarse en pantalla.

**Pantallas finales:** `pantallaVictoria` y `pantallaDerrota` entienden el mismo mensaje `mostrar()`. Quien termina el juego le pide a la pantalla que corresponda que se muestre, sin preguntar con un `if` si se ganó o se perdió.

## Herencia

**`Puerta`:** `puertaAnubis`, `puertaArtista` y `puertaFinal` heredan de ella y redefinen solo lo que cambia.
- `PuertaTrampaTeletransportacion` extiende `cruzar()` y llama a `super()`.
- `PuertaTrampaRestaTiempo` redefine `chocarConJugador()`.

**`ElementoInteractivo`:** es la clase base de estatuas, marcos, mesa y menú. Define como no-ops los mensajes `chocarConJugador()`, `abrirMenu()`, `marcarVerdad()` y `marcarFalso()`, para que el teclado pueda mandárselos a cualquier elemento.

**`Estatua`:** clase abstracta que junta el comportamiento de las estatuas (posición, diálogo, manejo de menú y cambio de estado), de ella heredan `EstatuaVerdadera` y `EstatuaMentirosa`. 

**`EstadoEstatua`:** hereda de `ElementoInteractivo` y suma las interacciones visuales (`mostrar()` y `ocultar()`). De ella heredan `EstadoNeutral` `EstadoVerdad` y `EstadoFalso`.

**`PantallaFinal`:** clase abstracta de la que heredan las pantallas finales.

## Template method

**`PantallaFinal`:** define el "molde": `text()` arma `titulo()` + " - " + `detalle()`, y `mostrar()` limpia el juego y agrega la pantalla. Cada pantalla redefine solamente `titulo()` y `detalle()`. Así el formato no se repite, y agregar otra pantalla final (por ejemplo, "te atrapó el guardia") es solo crear un objeto nuevo con su título y su detalle.

**`Puerta`:** `chocarConJugador()` es el molde (si `puedePasar()` → `cruzar()`, si no → dice `mensajeBloqueo()`), y cada puerta completa los pasos que varían.

## WKO y estados

`player`, `reloj`, `mochila`, `administradorDeSalas` y las salas son objetos únicos que conservan su estado aunque `game.clear()` saque todo de la pantalla al cambiar de sala (inventario, desgaste de disfraces, minutos restantes, estado de los puzzles).

El `reloj` arranca en 360 minutos (de 12:00 a 18:00) y pasa un minuto de juego por cada segundo real, con `game.onTick`.

## Encapsulamiento y delegación

**`reloj`:** nadie modifica los minutos directamente, se le pide `restarMinutos(n)`. Así la puerta trampa puede quitar tiempo sin saber cómo está hecho el reloj por dentro, y es el reloj quien sabe cuándo se terminó el tiempo (`seTerminoElTiempo()`).

**`player`:** delega el desgaste en su disfraz (`disfraz.desgastar(self)`). Cada disfraz decide cuándo se rompe y se lo avisa con `romperDisfraz()`.

**`administradorEstatuas` y `administradorMarcos`:** las puertas preguntan `estanTodasResueltas()` / `puzzleResuelto()` sin conocer las estatuas o los marcos individuales.

## Colecciones

- `administradorEstatuas.estatuas()` y `administradorMarcos.marcos()` son listas sobre las que se usan `forEach` (para dibujar) y `all` (para verificar si el puzzle está resuelto).
- `mochila.objetos()` guarda el inventario con `add`, `contains` y `remove`.
- `Marco` guarda una lista de imágenes (`galeria`) y la recorre con el módulo para cambiar de cuadro.
---

# Diagramas

falta completar aca