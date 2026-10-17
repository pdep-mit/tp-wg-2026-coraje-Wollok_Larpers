import wollok.game.*

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