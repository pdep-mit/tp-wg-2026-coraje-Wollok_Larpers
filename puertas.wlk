import wollok.game.*
import player.*
import escenarios.*
import disfraces.*
import interactuables.*
import llave.*

class Puerta {
    var property position
    var property proximaSala
    var property posicionJugador

    method image() = "puerta_1celda.png"
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

    method puedePasar() = true 
    method mensajeBloqueo() = "La puerta está cerrada."

    method cruzar() {
        administradorDeSalas.cambiarA(proximaSala, posicionJugador)
    }
}

object puertaAnubis inherits Puerta(
    position = game.at(7, 7), 
    proximaSala = habitacionDos,
    posicionJugador = game.at(2, 2)
) {
    override method puedePasar() = player.disfraz().permiteAccesoAnubis()
    override method mensajeBloqueo() = "Necesitás el disfraz de Anubis para pasar."
}

object puertaArtista inherits Puerta(
    position = game.at(8, 4), 
    proximaSala = habitacionTres,
    posicionJugador = game.at(2, 2)
) {
    override method puedePasar() = player.disfraz().permiteAccesoArtista() and administradorMarcos.puzzleResuelto()
    override method mensajeBloqueo() {
        if (!administradorMarcos.puzzleResuelto()) {
            return "Las pinturas aún no están en orden."
        }
        return "El guardián de la galería exige que vistas como artista."
    }
}

object puertaFinal inherits Puerta(
    position = game.at(5,8), 
    proximaSala = salaPrincipal, 
    posicionJugador = game.at(4,4)
) {
    override method puedePasar() = administradorEstatuas.estanTodasResueltas()
    override method mensajeBloqueo() = "Una magia bloquea la puerta. Resolvé el puzzle de estatuas."
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

class PuertaTrampaSacaItem inherits Puerta(
    proximaSala = salaPrincipal, 
    posicionJugador = game.at(0,0) 
) {
    override method chocarConJugador() {
        player.inventario().objetos().clear() 
        game.say(player, "¡Puerta trampa! Perdiste todos tus items.")
    }
}