import wollok.game.*
import player.*
import escenarios.* 

class ElementoInteractivo {
    var property position
    method chocarConJugador() {} 
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}
}
object menuFlotante inherits ElementoInteractivo(position = game.at(4, 8)) {
    method text() = " [V] Verdadero  |  [F] Falso "
    method textColor() = "FFFFFFFF"
}

class IndicadorEstado inherits ElementoInteractivo {
    var property estado = "neutral"

    method image() {
        if (estado == "verdad") return "marca_v.png"
        return "marca_f.png"
    }
}
object administradorEstatuas{
    const estatua1 = new EstatuaMentirosa(
        position = game.at(3, 4), 
        dialogo = "La mayoría de nosotras decimos la verdad     "
    )
    const estatua2 = new EstatuaVerdadera(
        position = game.at(4, 5), 
        dialogo = "La mayoría de nosotras somos mentirosas     "
    )
    const estatua3 = new EstatuaMentirosa(
        position = game.at(5, 6), 
        dialogo = "Todas excepto yo mienten   "
    )
    
    const estatua4 = new EstatuaMentirosa(
        position = game.at(6, 5), 
        dialogo = "Solo hay una mentirosa entre nosotras    "
    )
    
    const estatua5 = new EstatuaVerdadera(
        position = game.at(7, 4), 
        dialogo = "Al menos dos de nosotras somos mentirosas   "
    )

    const property estatuas = [estatua1, estatua2, estatua3, estatua4, estatua5]

    method dibujarEstatuas() {
        estatuas.forEach({ estatua => estatua.dibujarEnJuego() })
    }

    method estanTodasResueltas() {
        return estatuas.all({ estatua => estatua.estaCorrecta() })
    }
}

class Estatua inherits ElementoInteractivo {
    const dialogo
    var property estado = "neutral"
    var indicador = null

    method initialize() {
        indicador = new IndicadorEstado(
            position = game.at(self.position().x(), self.position().y() + 1))
    }

    method dibujarEnJuego() {
        game.addVisual(self)
    }
    method image() = "puzzles/estatua.png"

    override method chocarConJugador() {
        game.say(self, dialogo + "(Presioná 'E' para elegir)")
    }
    override method abrirMenu() {
        if (!game.hasVisual(menuFlotante)) {
            game.addVisual(menuFlotante)
        }
    }

    override method marcarVerdad() {
        estado = "verdad"
        indicador.estado("verdad")
        if (!game.hasVisual(indicador)) {
            game.addVisual(indicador)
        }
        if (game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    override method marcarFalso() {
        estado = "falso"
        indicador.estado("falso")
        if (!game.hasVisual(indicador)) {
            game.addVisual(indicador)
        }
        if (game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    method diceLaVerdad()
    method estaCorrecta() = (self.diceLaVerdad() and estado == "verdad") or (!self.diceLaVerdad() and estado == "falso")
}

// aca hice una clase abstracta estatua, antes era solo estatuaMentirosa y pense que era mejor hacer dos clases que redefinan el metodo de diceLaVerdad e instanciar solamente verdadera o mentirosa y no romana como era antes (ahora class Estatua)
class EstatuaVerdadera inherits Estatua {
    override method diceLaVerdad() = true
}

class EstatuaMentirosa inherits Estatua {
    override method diceLaVerdad() = false
}

class Marco inherits ElementoInteractivo {
    const galeria = ["puzzles/marco.png", "puzzles/marco_mujer.png", "puzzles/marco_gallo.png", "puzzles/marco_paisaje.png", "puzzles/marco_castillo.png"]
    var indiceActual = 0
    const imagenCorrecta

    method image() = galeria.get(indiceActual)
    method dibujarEnJuego() {
        game.addVisual(self)
    }

    override method chocarConJugador() {
        game.say(self, "Un marco antiguo... (Presioná 'E')")
    }

    override method abrirMenu() {
        indiceActual = (indiceActual + 1) % galeria.size()
    }

    method estaCorrecto() = self.image() == imagenCorrecta
}
object poemaGrande {
    var property position = game.at(2, 2) 
    method image() = "puzzles/poema.png"
}
object mesaPoema inherits ElementoInteractivo(position = game.at(1, 1)) {
    
    method image() = "ambientacion/mesa.png"
    
    method dibujarEnJuego() {
        game.addVisual(self)
    }

    override method chocarConJugador() {
        game.say(self, "Parece un poema...(Presioná 'E')")
    }

    override method abrirMenu() {
        if (game.hasVisual(poemaGrande)) {
            game.removeVisual(poemaGrande)
        } else {
            game.addVisual(poemaGrande)
        }
    }
}
object administradorMarcos {
    const marco1 = new Marco(
        position = game.at(1, 5),
        imagenCorrecta = "puzzles/marco_paisaje.png" 
    )
    const marco2 = new Marco(
        position = game.at(3, 5), 
        imagenCorrecta = "puzzles/marco_mujer.png"
    )
    const marco3 = new Marco(
        position = game.at(5, 5), 
        imagenCorrecta = "puzzles/marco_castillo.png"
    )
    const marco4 = new Marco(
        position = game.at(7, 5),
        imagenCorrecta = "puzzles/marco_gallo.png"
    )

    const property marcos = [marco1, marco2, marco3,marco4]

    method dibujarPuzzle() {
        mesaPoema.position(game.at(4, 2))
        mesaPoema.dibujarEnJuego()
        
        marcos.forEach({ marco => marco.dibujarEnJuego() })
    }

    method puzzleResuelto() {
        return marcos.all({ marco => marco.estaCorrecto() })
    }
}
