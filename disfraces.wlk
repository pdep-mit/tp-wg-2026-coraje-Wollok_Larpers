import player.*

object sinDisfraz {
  method image() = "jugador/jugador_sin_disfraz.png"
}

object disfrazArtista {
  method image() = "jugador/jugador_artista.png"
}
object disfrazPolicia {
  method image() = "jugador/jugador_policia.png"
}

object disfrazAnubis {
  method image() = "jugador/jugador_anubis.png"
}

object activadorArtista {
  var property position = game.at(5, 5)
  
  method image() = "activadorArtista.png"
  
  method activar() {
    //le mando el mensaje al personaje que colisiono y le paso el activador con self
    game.onCollideDo(self, {personaje => personaje.agarrarDisfrazArtista(self)})
  }
}