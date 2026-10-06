import wollok.game.*
import disfraces.*
import inventario.*

object player {
  var property position = game.at(1, 1)
  var property disfraz = sinDisfraz
  var property inventario = mochila
    
  method image() = disfraz.image()
    
  method ponerseDisfraz(nuevoDisfraz) {
    disfraz = nuevoDisfraz
  }
    
  method tiene(objeto) = inventario.contiene(objeto)
    
  method agregarAlInventario(objeto) {
    inventario.agregar(objeto)
  }
}