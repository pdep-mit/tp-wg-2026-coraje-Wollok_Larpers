import wollok.game.*
import disfraces.*
import inventario.*

object player {
  var property position = game.at(1, 1)
  var property disfraz = disfrazPolicia
  var property inventario = mochila
    
  method image() = disfraz.image()
    
  method ponerseDisfraz(nuevoDisfraz) {
    disfraz = nuevoDisfraz
  }
    
  method tiene(objeto) = inventario.contiene(objeto)
    
  method agregarAlInventario(objeto) {
    inventario.agregar(objeto)
  }

  method desgastarDisfrazActual() {
    disfraz.desgastar(self)
  }

  method romperDisfraz(disfrazRoto) {
    inventario.quitar(disfrazRoto)
    self.ponerseDisfraz(disfrazPolicia) 
    game.say(self, "¡Perdiste el disfraz!")
  }
}