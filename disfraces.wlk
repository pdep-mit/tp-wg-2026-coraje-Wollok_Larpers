import player.*

object disfrazPolicia {
  method image() = "jugador/jugador_policia.png"
  
  method desgastar(personaje) { } 
  method teAtacaGuardia() = false
  method teAtacaCuadroVivo() = false
  method teAtacaEstatua() = true
  method abrePuertaModerna() = false
}

object disfrazAnubis {
  var desgaste = 0

  method image() {
    if (desgaste < 20) return "jugador/jugador_anubis.png"
    if (desgaste >= 20 and desgaste < 40) return "jugador/anubis_desgaste.png"
    return "jugador/anubis_desgaste2.png"
  }

  method desgastar(personaje) {
    desgaste += 1
    if (desgaste >= 60) {  
      personaje.romperDisfraz(self)
      desgaste = 0
    }
  }

  method teAtacaGuardia() = true
  method teAtacaCuadroVivo() = true
  method teAtacaEstatua() = true
  method abrePuertaModerna() = true
}

object disfrazArtista {
  var desgaste = 0

  method image() {
    if (desgaste < 20) return "jugador/jugador_artista.png"
    if (desgaste < 40) return "jugador/artista_desgaste.png"
    return "jugador/artista_desgaste2.png"
  }

  method desgastar(personaje) {
    desgaste += 1
    if (desgaste >= 60) {
      personaje.romperDisfraz(self)
      desgaste = 0
    }
  }

  method teAtacaGuardia() = true
  method teAtacaCuadroVivo() = false
  method teAtacaEstatua() = false
  method abrePuertaModerna() = false
}

object activadorAnubis {
  var property position = game.at(6, 2)

  method image() = "activadorAnubis.png"
    
  method chocarConJugador(){
    player.agregarAlInventario(disfrazAnubis)
    game.say(player, "¡Conseguiste el disfraz de Anubis! Podes cambiar de disfraz con las teclas 1-4.")
    game.schedule(100, { game.removeVisual(self) })
  }
}

object activadorArtista {
  var property position = game.at(7,3)

  method image() = "activadorArtista.png"

  method chocarConJugador(){
    player.agregarAlInventario(disfrazArtista)
    game.say(player, "¡Conseguiste el disfraz de Artista! Podes cambiar de disfraz con las teclas 1-4.")
    game.schedule(100, { game.removeVisual(self) })
  }
}