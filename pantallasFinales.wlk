import wollok.game.*

class PantallaFinal {
  method titulo()
  method detalle()

  method text() = self.titulo() + " - " + self.detalle()

  method position() = game.center()

  method textColor() = "000000FF"

  method mostrar() {
    game.clear()            
    game.addVisual(self)
  }
}

/*object pantallaVictoria inherits PantallaFinal {
  override method titulo() = "¡ESCAPASTE DEL MUSEO!"
  override method detalle() = "Saliste antes de que cierren"
}*/


object pantallaDerrota inherits PantallaFinal {
  override method titulo() = "GAME OVER"
  override method detalle() = "Son las 18:00 y cerró el museo"
}
