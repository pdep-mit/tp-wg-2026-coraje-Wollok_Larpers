import wollok.game.*
import player.*
import movimientos.*
import llave.*
import disfraces.*
import reloj.*

class Fondo {
    var property position = game.at(0, 0)
    var property image
    method chocarConJugador() {}
}
class Puerta {
    var property position
    var property image = "puerta_1celda.png"
    var property proximaSala
    var property posicionJugador

    method chocarConJugador() {
        administradorDeSalas.cambiarA(proximaSala, posicionJugador)
    }
}

object puertaFinal {
    var property position = game.at(7,7)
    var property image = "puerta_1celda.png"
    var property gano = false

    method chocarConJugador(){
        if(player.tiene(llave)) {
            gano = true
            game.say(player, "Ganaste!!!")
        } else{
            game.say(player, "Te falta la llave maestro")
        }
    }
}

object administradorDeSalas {
    method iniciar() {
        self.cambiarA(salaPrincipal, game.at(2, 2))
    }

    method cambiarA(nuevaSala, posicionJugador) {
        game.clear()
        nuevaSala.dibujar()
        self.configurarJugador(posicionJugador)
        reloj.ponerEnPantalla()
    }

    method configurarJugador(posicionJugador) {
        player.position(posicionJugador)
        game.addVisual(player)

        keyboard.up().onPressDo({ movimientos.mover(player, haciaArriba) })
        keyboard.down().onPressDo({ movimientos.mover(player, haciaAbajo) })
        keyboard.left().onPressDo({ movimientos.mover(player, haciaLaIzquierda) })
        keyboard.right().onPressDo({ movimientos.mover(player, haciaLaDerecha) })
        
        keyboard.num1().onPressDo({ player.ponerseDisfraz(sinDisfraz) })
        keyboard.num2().onPressDo({ 
            if (player.tiene(disfrazAnubis)) player.ponerseDisfraz(disfrazAnubis) 
        })

        game.onCollideDo(player, { elemento => elemento.chocarConJugador() })
    }
}

object salaPrincipal {
    method dibujar() {
        game.addVisual(new Fondo(image = "habitacion_cero.png"))
        
        const puertaA1 = new Puerta(
            position = game.at(4, 7),
            proximaSala = habitacionUno,
            posicionJugador = game.at(2, 5) 
        )
        game.addVisual(puertaA1)
        if(!player.tiene(llave)){
            game.addVisual(llave)
        }
    }
}

object habitacionUno {
    method dibujar() {
        game.addVisual(new Fondo(image = "habitacion_uno.png"))

        const puertaVolver = new Puerta(
            position = game.at(4, 7), 
            proximaSala = salaPrincipal,
            posicionJugador = game.at(4, 6) 
        )
        game.addVisual(puertaVolver)
        game.addVisual(puertaFinal)
        if(!player.tiene(disfrazAnubis)){
            game.addVisual(activadorAnubis)
        }
    }
}