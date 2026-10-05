import player.*

object llave {
  var property position = game.at(15, 5)
  
  method image() = "llave.png"
  
  method activar() {
    game.onCollideDo(self, {personaje => personaje.agarrarLlave(self)})
  }
}