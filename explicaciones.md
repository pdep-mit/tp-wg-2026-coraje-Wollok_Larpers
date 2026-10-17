# Explicaciones teóricas

*Completar comentando dónde se aplicaron los distintos conceptos buscados*

## Reloj y pantallas finales

**Estado:** el `reloj` guarda `minutosRestantes` y lo va cambiando. Arranca en 360 (de las 12:00 a las 18:00) y cada segundo real pasa un minuto del juego (con `game.onTick`). Como es un objeto, conserva su estado aunque `game.clear()` lo saque de la pantalla al cambiar de sala: cuando se vuelve a poner, sigue desde la misma hora.

**Encapsulamiento:** nadie modifica los minutos directamente, sino que se le pide al reloj `restarMinutos(n)`. Así la puerta trampa puede quitar tiempo sin saber cómo está hecho el reloj por dentro. El reloj también es el que sabe cuándo se terminó el tiempo (`seTerminoElTiempo()`).

**Polimorfismo:** `pantallaVictoria` y `pantallaDerrota` entienden el mismo mensaje `mostrar()`. Quien termina el juego le pide a la pantalla que corresponda que se muestre, sin preguntar con un `if` si se ganó o se perdió.

**Herencia y template method:** las dos pantallas heredan de la clase abstracta `PantallaFinal`. La clase define el "molde": cómo se arma el texto (`text()` = `titulo()` + " - " + `detalle()`) y cómo se muestra. Cada pantalla redefine solamente `titulo()` y `detalle()`. Así el formato no se repite, y agregar otra pantalla final (por ejemplo, "te atrapó el guardia") es solo crear un objeto nuevo con su título y su detalle.

**Tests:** `tests/testsReloj.wtest` prueba la lógica del reloj sin esperar tiempo real (usando `restarMinutos` y `pasarUnMinuto`) y el texto de las dos pantallas finales.

# Diagramas

*Incluír al menos un diagrama para comunicar su solución*

## Reloj y pantallas finales

```mermaid
classDiagram
  class reloj {
    <<object>>
    minutosRestantes
    pasarUnMinuto()
    restarMinutos(cantidad)
    seTerminoElTiempo()
    text()
    ponerEnPantalla()
  }
  class PantallaFinal {
    <<abstract>>
    titulo()*
    detalle()*
    text()
    mostrar()
  }
  class pantallaVictoria {
    <<object>>
    titulo()
    detalle()
  }
  class pantallaDerrota {
    <<object>>
    titulo()
    detalle()
  }
  class administradorDeSalas {
    <<object>>
    cambiarA(nuevaSala, posicionJugador)
  }
  PantallaFinal <|-- pantallaVictoria
  PantallaFinal <|-- pantallaDerrota
  reloj --> pantallaDerrota : mostrar() a las 18:00
  administradorDeSalas --> reloj : ponerEnPantalla()
```
