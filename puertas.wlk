import wollok.game.*
import player.*
import escenarios.*
import interactuables.*
import llave.*
import reloj.*

class Puerta {
    var property position
    var property proximaSala
    var property posicionJugador
    
    var property image = "ambientacion/puerta_1celda.png"
    var property condicionDePaso = { => true } 
    var property generadorMensaje = { => "La puerta está cerrada." }

    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}

    method chocarConJugador() {
        if (self.puedePasar()) {
            self.cruzar()
        } else {
            game.say(player, self.mensajeBloqueo())
        }
    }

    method puedePasar() = condicionDePaso.apply()
    method mensajeBloqueo() = generadorMensaje.apply()

    method cruzar() {
        administradorDeSalas.cambiarA(proximaSala, posicionJugador)
    }
}

class PuertaTrampaTeletransportacion inherits Puerta(
    proximaSala = salaPrincipal, 
    posicionJugador = game.at(4, 6)
) {
    override method cruzar() {
        game.say(player, "¡Puerta trampa! Volvés a la sala principal.")
        super() 
    }
}

class PuertaTrampaRestaTiempo inherits Puerta(
    proximaSala = salaPrincipal, 
    posicionJugador = game.at(0,0) 
) {
    override method chocarConJugador() {
        reloj.restarMinutos(10) 
        game.say(player, "¡Puerta trampa! Perdiste 10 minutos de tiempo.")
    } 
}

object cartelPuertas {
    method position() = game.at(2, 2) 
    method image() = "cartelPuertas.png"
    method chocarConJugador(){
        game.removeVisual(self)
    }
}