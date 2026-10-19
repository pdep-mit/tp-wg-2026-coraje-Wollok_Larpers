import wollok.game.*
import player.*
import movimientos.*
import llave.*
import disfraces.*
import interactuables.*

class Fondo {
    var property position = game.at(0, 0)
    var property image
    method chocarConJugador() {}
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}
}
class Puerta {
    var property position
    var property image = "puerta_1celda.png"
    var property proximaSala
    var property posicionJugador
    var property condicionParaPasar = { => true } 
    var property mensajeBloqueo = "La puerta está cerrada."
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}

    method chocarConJugador() {
        if (condicionParaPasar.apply()) { 
            administradorDeSalas.cambiarA(proximaSala, posicionJugador)
        } else {
            game.say(player, mensajeBloqueo)
        }
    }
}


object puertaFinal {
    var property position = game.at(5,8)
    var property image = "puerta_1celda.png"
    var property gano = false
    method abrirMenu() {}
    method marcarVerdad() {}
    method marcarFalso() {}

    method chocarConJugador(){
        if(!administradorEstatuas.estanTodasResueltas()) {
            game.say(player, "Una magia bloquea la puerta.")
        } 
        else if(player.tiene(llave)) {
            gano = true
            game.say(player, "Ganaste!!")
        } else {
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
        keyboard.e().onPressDo({ 
            const tocados = game.colliders(player)
            if (!tocados.isEmpty()) { tocados.first().abrirMenu() }
        })
        keyboard.v().onPressDo({ 
            const tocados = game.colliders(player)
            if (!tocados.isEmpty()) { tocados.first().marcarVerdad() }
        })
        keyboard.f().onPressDo({ 
            const tocados = game.colliders(player)
            if (!tocados.isEmpty()) { tocados.first().marcarFalso() }
        })
        game.onCollideDo(player, { elemento => elemento.chocarConJugador() })
        
        keyboard.v().onPressDo({ 
            const estatuaActiva = administradorEstatuas.estatuas().findOrDefault({ estatua => 
                game.hasVisual(menuFlotante) and 
                menuFlotante.position().x() == estatua.position().x() and 
                menuFlotante.position().y() == estatua.position().y() + 1
            }, null)
            
            if(estatuaActiva != null){
                estatuaActiva.marcarVerdad()
            }
        })
        
        keyboard.f().onPressDo({ 
            const estatuaActiva = administradorEstatuas.estatuas().findOrDefault({ estatua => 
                game.hasVisual(menuFlotante) and 
                menuFlotante.position().x() == estatua.position().x() and 
                menuFlotante.position().y() == estatua.position().y() + 1
            }, null)
            
            if(estatuaActiva != null){
                estatuaActiva.marcarFalso()
            }
        })
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

        const puertaA2 = new Puerta(
            position = game.at(7, 7), 
            proximaSala = habitacionDos,
            posicionJugador = game.at(2, 2) 
        )
        game.addVisual(puertaA2)
        if(!player.tiene(disfrazAnubis)){
            game.addVisual(activadorAnubis)
        }
    }
}

object habitacionDos {
    method dibujar() {
        game.addVisual(new Fondo(image = "habitacion_dos.png")) 

        const puertaVolver1 = new Puerta(
            position = game.at(1, 4), 
            proximaSala = habitacionUno,
            posicionJugador = game.at(6, 7)
        )
        game.addVisual(puertaVolver1)

        const puertaA3 = new Puerta(
            position = game.at(8, 4), 
            proximaSala = habitacionTres,
            posicionJugador = game.at(2, 2),
            condicionParaPasar = { => administradorMarcos.puzzleResuelto() },
            mensajeBloqueo = "Aún no resolviste el misterio de las pinturas."
        )
        game.addVisual(puertaA3)
        administradorMarcos.dibujarPuzzle()
    }
}

object habitacionTres {
    method dibujar() {
        game.addVisual(new Fondo(image = "habitacion_tres.png"))

        const puertaVolver2 = new Puerta(
            position = game.at(4, 1), 
            proximaSala = habitacionDos,
            posicionJugador = game.at(7, 4) 
        )
        game.addVisual(puertaVolver2)
        game.addVisual(puertaFinal)

        administradorEstatuas.dibujarEstatuas()
    }
 }  