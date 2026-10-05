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
  
  method agarrarDisfrazArtista(activador) {
    self.agregarAlInventario(disfrazArtista)
    game.removeVisual(activador)
    game.say(self, "Conseguiste el disfraz de artista! Podes cambiar de disfraz con las teclas 1-4.")
  }

  method agarrarLlave(llave) {
    self.agregarAlInventario(llave)
    game.removeVisual(llave)
    game.say(self, "Conseguiste la llave!")
  }
}