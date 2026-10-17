import wollok.game.*
import player.*
import escenarios.* 
object menuFlotante {
    var property position = game.at(4, 8)
    method image() = "menu_opciones.png" 
    
    method chocarConJugador() {} 
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}
}

class IndicadorEstado {
    var property position
    var property estado = "neutral"

    method image() {
        if (estado == "verdad") return "marca_v.png"
        if (estado == "falso") return "marca_f.png"
        return "vacio.png"
    }
    
    method chocarConJugador() {}
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}
}

class EstatuaRomana {
    var property position
    const dialogo
    var property estado = "neutral"
    var indicador = null

    method initialize() {
        indicador = new IndicadorEstado(
            position = game.at(self.position().x(), self.position().y() + 1))
    }

    method dibujarEnJuego() {
        game.addVisual(self)
        game.addVisual(indicador)
    }
    method image() = "estatua.png"

    method chocarConJugador() {
        game.say(self, dialogo + "(Presioná 'E' para elegir)")
    }
    method abrirMenu() {
        if (!game.hasVisual(menuFlotante)) {
            game.addVisual(menuFlotante)
        }
    }

    method marcarVerdad() {
        estado = "verdad"
        indicador.estado("verdad")
        if (game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    method marcarFalso() {
        estado = "falso"
        indicador.estado("falso")
        if (game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    method diceLaVerdad() = false
    method estaCorrecta() = (self.diceLaVerdad() and estado == "verdad") or (!self.diceLaVerdad() and estado == "falso")
}

class EstatuaVerdadera inherits EstatuaRomana {
    override method diceLaVerdad() = true
}