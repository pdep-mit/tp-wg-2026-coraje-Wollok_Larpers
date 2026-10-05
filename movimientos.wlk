import wollok.game.*

/* El metodo mover recibe el personaje y una direccion (arriba, abajo, derecha o izquierda).
Le pregunta a la direccion cual seria la posicion siguiente a partir de donde esta el personaje
y la guarda en nuevaPosicion. Si esa nuevaPosicion esta dentro de la sala, el personaje
pasa a ocupar esa posicion. Si no, se queda donde estaba. */
object movimientos {
  method mover(personaje, direccion) {
    const nuevaPosicion = direccion.posicionSiguiente(personaje.position())
    if (self.estaDentroDeLaSala(nuevaPosicion)) {
      personaje.position(nuevaPosicion)
    }
  }

  method estaDentroDeLaSala(pos) =
    pos.x().between(1, game.width() - 2) && pos.y().between(1, game.height() - 2)
}

object haciaArriba {
  method posicionSiguiente(posicion) = posicion.up(1)
}
object haciaAbajo {
  method posicionSiguiente(posicion) = posicion.down(1)
}
object haciaLaDerecha {
  method posicionSiguiente(posicion) = posicion.right(1)
}
object haciaLaIzquierda {
  method posicionSiguiente(posicion) = posicion.left(1)
}