import wollok.game.*
import player.*
import escenarios.* 
object menuFlotante {
    var property position = game.at(4, 8)
    method text() = " [V] Verdad   |   [F] Falso "
    method textColor() = "FFFFFFFF"
    
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
        return "marca_f.png"
    }
    
    method chocarConJugador() {}
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}
}
object administradorEstatuas{
    const estatua1 = new EstatuaRomana(
        position = game.at(3, 4), 
        dialogo = "La mayoría de nosotras decimos la verdad     "
    )
    const estatua2 = new EstatuaVerdadera(
        position = game.at(4, 5), 
        dialogo = "La mayoría de nosotras somos mentirosas     "
    )
    const estatua3 = new EstatuaRomana(
        position = game.at(5, 6), 
        dialogo = "Todas excepto yo mienten     "
    )
    
    const estatua4 = new EstatuaVerdadera(
        position = game.at(6, 5), 
        dialogo = "Solo hay una mentirosa entre nsotras     "
    )
    
    const estatua5 = new EstatuaVerdadera(
        position = game.at(7, 4), 
        dialogo = "Al menos dos de nosotras somos mentirosas    "
    )

    const property estatuas = [estatua1, estatua2, estatua3, estatua4, estatua5]

    method dibujarEstatuas() {
        estatuas.forEach({ estatua => estatua.dibujarEnJuego() })
    }

    method estanTodasResueltas() {
        return estatuas.all({ estatua => estatua.estaCorrecta() })
    }
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
        if (!game.hasVisual(indicador)) {
            game.addVisual(indicador)
        }
        if (!game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    method marcarFalso() {
        estado = "falso"
        indicador.estado("falso")
        if (!game.hasVisual(indicador)) {
            game.addVisual(indicador)
        }
        if (game.hasVisual(menuFlotante)) { game.removeVisual(menuFlotante) }
    }

    method diceLaVerdad() = false
    method estaCorrecta() = (self.diceLaVerdad() and estado == "verdad") or (!self.diceLaVerdad() and estado == "falso")
}

class EstatuaVerdadera inherits EstatuaRomana {
    override method diceLaVerdad() = true
}    