import wollok.game.*

// Clase abstracta con TEMPLATE METHOD:
// la clase define los pasos (cómo se arma y se muestra la pantalla)
// y cada pantalla concreta completa las partes que cambian.
class PantallaFinal {
  // ---------- Partes que cada pantalla tiene que redefinir (abstractas) ----------
  method titulo()
  method detalle()

  // ---------- Template method: el "molde" es igual para todas ----------
  method text() = self.titulo() + " - " + self.detalle()

  method position() = game.center()

  method textColor() = "000000FF"

  // Mismo mensaje para todas las pantallas (polimorfismo):
  // quien la llama no necesita saber si ganó o perdió.
  method mostrar() {
    game.clear()            // saca todo: visuales, teclado y el onTick del reloj
    game.addVisual(self)
  }
}

object pantallaVictoria inherits PantallaFinal {
  override method titulo() = "¡ESCAPASTE DEL MUSEO!"
  override method detalle() = "Saliste antes de que cierren"
}

object pantallaDerrota inherits PantallaFinal {
  override method titulo() = "GAME OVER"
  override method detalle() = "Son las 18:00 y cerró el museo"
}
