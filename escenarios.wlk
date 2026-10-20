import wollok.game.*
import player.*
import movimientos.*
import llave.*
import disfraces.*
import interactuables.*
import reloj.*
import puertas.*

class Fondo {
    var property position = game.at(0, 0)
    var property image
}

object administradorDeSalas {
    method iniciar() {
        self.cambiarA(salaPrincipal, game.at(2, 5))
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
        
        keyboard.num1().onPressDo({ player.ponerseDisfraz(disfrazPolicia) })
        keyboard.num2().onPressDo({ 
            if (player.tiene(disfrazAnubis)) player.ponerseDisfraz(disfrazAnubis) 
        })
        keyboard.num3().onPressDo({
            if (player.tiene(disfrazArtista)) player.ponerseDisfraz(disfrazArtista)
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
        game.addVisual(new Fondo(image = "ambientacion/habitacion_cero.png"))
        
        const puertaA1 = new Puerta(
            position = game.at(4, 8),
            proximaSala = habitacionUno,
            posicionJugador = game.at(2, 1) 
        )
        game.addVisual(puertaA1)
        if(!player.tiene(llave)){
            game.addVisual(llave)
        }
        if(!player.tiene(disfrazArtista)){
            game.addVisual(activadorArtista)
        }
    }
}

object habitacionUno {
    method dibujar() {
        game.addVisual(new Fondo(image = "ambientacion/habitacion_uno.png"))

        const puertaVolver1 = new Puerta(
            position = game.at(1, 1), 
            proximaSala = salaPrincipal,
            posicionJugador = game.at(4, 7) 
        )
        game.addVisual(puertaVolver1)
        game.addVisual(puertaAnubis)
        game.addVisual(cartelPuertas)

        if(!player.tiene(disfrazAnubis)){
            game.addVisual(activadorAnubis)
        }
        const trampa1 = new PuertaTrampaTeletransportacion(position = game.at(2, 8))
        game.addVisual(trampa1)

        const trampa2 = new PuertaTrampaRestaTiempo(position = game.at(4, 8))
        game.addVisual(trampa2)

        const trampa3 = new PuertaTrampaRestaTiempo(position = game.at(6,8))
        game.addVisual(trampa3)

        const trampa4 = new PuertaTrampaTeletransportacion(position = game.at(8,8))
        game.addVisual(trampa4)
    }
}


object habitacionDos {
    method dibujar() {
        game.addVisual(new Fondo(image = "ambientacion/habitacion_dos.png")) 

        const puertaVolver2 = new Puerta(
            position = game.at(1, 4), 
            proximaSala = habitacionUno,
            posicionJugador = game.at(3, 3)
        )
        game.addVisual(puertaVolver2)

        game.addVisual(puertaArtista)
        administradorMarcos.dibujarPuzzle()
    }
}

object habitacionTres {
    method dibujar() {
        game.addVisual(new Fondo(image = "ambientacion/habitacion_tres.png"))

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