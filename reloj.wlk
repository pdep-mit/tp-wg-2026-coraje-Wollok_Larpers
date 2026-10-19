import wollok.game.*
import pantallasFinales.*
import player.*

object reloj {
  const minutosTotales = 360        
  var minutosRestantes = minutosTotales

  method minutosRestantes() = minutosRestantes

  method seTerminoElTiempo() = minutosRestantes == 0

  method minutosPasados() = minutosTotales - minutosRestantes

  method hora() = 12 + self.minutosPasados().div(60)

  method minuto() = self.minutosPasados() % 60

  method pasarUnMinuto() {
    self.restarMinutos(1)
    player.desgastarDisfrazActual()
  }

  method restarMinutos(cantidad) {
    minutosRestantes = (minutosRestantes - cantidad).max(0)
    if (self.seTerminoElTiempo()) {
      pantallaDerrota.mostrar()
    }
  }

  method position() = game.at(0, 9)

  method text() = self.hora().toString() + ":" + self.dosDigitos(self.minuto())

  method textColor() = "FFD700FF"

  method dosDigitos(numero) = if (numero < 10) "0" + numero.toString() else numero.toString()

  method ponerEnPantalla() {
    game.addVisual(self)
    game.onTick(1000, "pasoDelTiempo", { self.pasarUnMinuto() })
  }
}
