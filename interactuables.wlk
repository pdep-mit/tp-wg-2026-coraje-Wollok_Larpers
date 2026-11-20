import wollok.game.*

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

class EstadoEstatua inherits ElementoInteractivo {
    method coincideCon(diceLaVerdad)
    method mostrar() {
        if (!game.hasVisual(self)) {
            game.addVisual(self)
        }
    }
    method ocultar() {
        if (game.hasVisual(self)) {
            game.removeVisual(self)
        }
    }
}

class EstadoNeutral inherits EstadoEstatua {
    override method coincideCon(diceLaVerdad) = false
    override method mostrar() {} 
    override method ocultar() {}
}

class EstadoVerdad inherits EstadoEstatua {
    method image() = "marca_v.png"
    override method coincideCon(diceLaVerdad) = diceLaVerdad
}

class EstadoFalso inherits EstadoEstatua {
    method image() = "marca_f.png"
    override method coincideCon(diceLaVerdad) = !diceLaVerdad
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

    method reiniciarPuzzle() {
        estatuas.forEach({ estatua => estatua.reiniciar() })
    }
}

class Estatua inherits ElementoInteractivo {
    const dialogo
    var estado = null

    method initialize() {
        estado = new EstadoNeutral(position = self.posicionIndicador())
    }
    method posicionIndicador() = game.at(self.position().x(), self.position().y() + 1)
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
    method cerrarMenu() {
        if (game.hasVisual(menuFlotante)) {
            game.removeVisual(menuFlotante)
        }
    }
    method cambiarEstado(nuevoEstado) {
        estado.ocultar()
        estado = nuevoEstado
        estado.mostrar()
    }

    override method marcarVerdad () {
        self.cambiarEstado(new EstadoVerdad(position = self.posicionIndicador()))
        self.cerrarMenu()
    }
    override method marcarFalso() {
        self.cambiarEstado(new EstadoFalso(position = self.posicionIndicador()))
        self.cerrarMenu()
    }
    method reiniciar() {
        self.cambiarEstado(new EstadoNeutral(position = self.posicionIndicador()))
    }

    method diceLaVerdad()
    method estaCorrecta() = estado.coincideCon(self.diceLaVerdad())
}

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

    method reiniciar() {
        indiceActual = 0
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
    method reiniciarPuzzle() {
        marcos.forEach({ marco => marco.reiniciar() })
    }
}
