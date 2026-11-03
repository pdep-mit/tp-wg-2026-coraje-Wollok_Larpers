# Explicaciones teóricas

*A continuación presentamos dónde aplicamos los distintos conceptos que se buscaban en cada entrega.*

## Índice

- [Polimorfismo](#polimorfismo)
- [Herencia](#herencia)

---

## Polimorfismo

**Puertas:** todas las puertas entienden `puedePasar()` y `mensajeBloqueo()`, y cada una lo resuelve a su manera.
- `puertaAnubis` le pregunta al disfraz del jugador.
- `puertaArtista` pide que el puzzle de marcos esté resuelto, además del disfraz.
- `puertaFinal` pide que las estatuas estén resueltas y que el jugador tenga la llave.

**Disfraces:** `disfrazPolicia`, `disfrazAnubis` y `disfrazArtista` entienden los mensajes `image()`, `desgastar(personaje)`, `permiteAccesoAnubis()` y `permiteAccesoArtista()`. El jugador y las puertas los usan sin preguntar cual es cual.

**Visuales:** se le manda el mensaje `chocarConJugador()` a cualquier cosa con la que choque el jugador (puertas, llave, activadores de disfraz, estatuas, marcos, etc.) y cada una hace lo suyo.

**Pantallas finales:** `pantallaVictoria` y `pantallaDerrota` entienden el mismo mensaje `mostrar()`. Quien termina el juego le pide a la pantalla que corresponda que se muestre, sin preguntar con un `if` si se ganó o se perdió.

## Herencia

**`Puerta`:** `puertaAnubis`, `puertaArtista` y `puertaFinal` heredan de ella y redefinen solo lo que cambia.
- `PuertaTrampaTeletransportacion` extiende `cruzar()` y llama a `super()`.
- `PuertaTrampaRestaTiempo` redefine `chocarConJugador()`.

**`ElementoInteractivo`:** es la clase base de estatuas, marcos, mesa y menú. Define como no-ops los mensajes `chocarConJugador()`, `abrirMenu()`, `marcarVerdad()` y `marcarFalso()`, para que el teclado pueda mandárselos a cualquier elemento.

**`EstatuaRomana` / `EstatuaVerdadera`:** la segunda hereda de la primera y solo redefine `diceLaVerdad()`.

**`PantallaFinal`:** clase abstracta de la que heredan las pantallas finales.

## Template method

**`PantallaFinal`:** define el "molde": `text()` arma `titulo()` + " - " + `detalle()`, y `mostrar()` limpia el juego y agrega la pantalla. Cada pantalla redefine solamente `titulo()` y `detalle()`. Así el formato no se repite, y agregar otra pantalla final (por ejemplo, "te atrapó el guardia") es solo crear un objeto nuevo con su título y su detalle.

**`Puerta`:** `chocarConJugador()` es el molde (si `puedePasar()` → `cruzar()`, si no → dice `mensajeBloqueo()`), y cada puerta completa los pasos que varían.

---

# Diagramas

falta completar aca