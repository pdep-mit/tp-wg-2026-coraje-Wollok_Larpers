import wollok.game.*
import player.*

object llave {
  var property position = game.at(5, 2)
    
  method image() = "llave.png"
    
  method chocarConJugador() {
    player.agregarAlInventario(self)
    game.say(player, "¡Conseguiste la llave!") 
    game.schedule(100, { game.removeVisual(self) })
  }
}