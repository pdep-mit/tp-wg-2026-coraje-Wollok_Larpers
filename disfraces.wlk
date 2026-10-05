import player.*

object sinDisfraz {
  method image() = "jugador/jugador_sin_disfraz.png"
  method teAtacaGuardia() = true
  method teAtacaCuadroVivo() = false
  method teAtacaEstatua() = true
  method abrePuertaModerna() = true
}

object disfrazArtista {
  method image() = "jugador/jugador_artista.png"
  method teAtacaGuardia() = true
  method teAtacaCuadroVivo() = true
  method teAtacaEstatua() = true
  method abrePuertaModerna() = true
}
object disfrazPolicia {
  method image() = "jugador/jugador_policia.png"
  method teAtacaGuardia() = false
  method teAtacaCuadroVivo() = false
  method teAtacaEstatua() = true
  method abrePuertaModerna() = false
}

object disfrazAnubis {
  method image() = "jugador/jugador_anubis.png"
  method teAtacaGuardia() = true
  method teAtacaCuadroVivo() = false
  method teAtacaEstatua() = false
  method abrePuertaModerna() = false
}

object activadorArtista {
  var property position = game.at(5, 5)
  
  method image() = "activadorArtista.png"
  
  method activar() {
    //le mando el mensaje al personaje que colisiono y le paso el activador con self
    game.onCollideDo(self, {personaje => personaje.agarrarDisfrazArtista(self)})
  }
}