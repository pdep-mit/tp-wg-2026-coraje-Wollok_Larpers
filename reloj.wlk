import wollok.game.*
import pantallasFinales.*

// El reloj del museo: entrás a las 12:00 y tenés hasta las 18:00 para salir.
// Funciona como las "vidas" del jugador: cuando se queda sin minutos, perdés.
object reloj {
  const minutosTotales = 360        // de 12:00 a 18:00 hay 6 horas = 360 minutos
  var minutosRestantes = minutosTotales

  // ---------- Consultas (no cambian nada, solo responden) ----------
  method minutosRestantes() = minutosRestantes

  method seTerminoElTiempo() = minutosRestantes == 0

  method minutosPasados() = minutosTotales - minutosRestantes

  method hora() = 12 + self.minutosPasados().div(60)

  method minuto() = self.minutosPasados() % 60

  // ---------- Acciones (cambian el estado del reloj) ----------
  method pasarUnMinuto() {
    self.restarMinutos(1)
  }

  // La usa también la puerta trampa (Persona 2): reloj.restarMinutos(30)
  method restarMinutos(cantidad) {
    minutosRestantes = (minutosRestantes - cantidad).max(0)
    if (self.seTerminoElTiempo()) {
      pantallaDerrota.mostrar()
    }
  }

  // ---------- Lo que necesita Wollok Game para dibujarlo ----------
  method position() = game.at(0, 9)

  method text() = self.hora().toString() + ":" + self.dosDigitos(self.minuto())

  method textColor() = "FFD700FF"

  method dosDigitos(numero) = if (numero < 10) "0" + numero.toString() else numero.toString()

  // Se llama cada vez que se dibuja una sala (desde administradorDeSalas.cambiarA),
  // porque game.clear() borra el reloj de la pantalla y frena su onTick.
  // Los minutos NO se reinician: el reloj sigue contando desde donde estaba.
  method ponerEnPantalla() {
    game.addVisual(self)
    game.onTick(1000, "pasoDelTiempo", { self.pasarUnMinuto() })
  }
}
