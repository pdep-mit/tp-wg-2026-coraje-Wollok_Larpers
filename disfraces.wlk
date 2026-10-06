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
  var property position = game.at(6, 2)

  method image() = "activadorArtista.png"
    
  method chocarConJugador() {
    player.agregarAlInventario(disfrazArtista)
    game.say(player, "¡Conseguiste el disfraz de artista! Podes cambiar de disfraz con las teclas 1-4.")
    game.schedule(100, { game.removeVisual(self) })
  }
}