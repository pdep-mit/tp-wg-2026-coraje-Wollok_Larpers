import wollok.game.*

class PantallaFinal {
  method image()

  method position() = game.origin()

  method textColor() = "000000FF"

  method mostrar() {
    game.clear()            
    game.addVisual(self)
  }
}

//la pantallaVictoria es dibujada por el objeto habitacionFinal en escenarios.wlk y la pantallaDerrota por restarMinutos en reloj.wlk
object pantallaVictoria inherits PantallaFinal {
  override method image() = "ambientacion/habitacion_finalBueno.png"
}


object pantallaDerrota inherits PantallaFinal {
  override method image() = "ambientacion/habitacion_finalMalo.png"
}
