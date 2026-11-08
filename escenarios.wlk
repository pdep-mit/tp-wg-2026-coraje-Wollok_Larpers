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
    var property juegoTerminado = false

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

        if(!juegoTerminado){
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
        }
    }
    method reiniciar() {
        self.juegoTerminado(false)
        reloj.reiniciar()
        player.reiniciar()
        administradorEstatuas.reiniciarPuzzle()
        administradorMarcos.reiniciarPuzzle()
        self.iniciar()
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
    var cartelYaMostrado = false
    method dibujar() {
        game.addVisual(new Fondo(image = "ambientacion/habitacion_uno.png"))

        const puertaVolver1 = new Puerta(
            position = game.at(1, 1), 
            proximaSala = salaPrincipal,
            posicionJugador = game.at(4, 7) 
        )
        const puertaAnubis = new Puerta(
            position = game.at(3, 4), 
            proximaSala = habitacionDos,
            posicionJugador = game.at(2, 4),
            image = "ambientacion/esfinge.png",
            condicionDePaso = { => player.disfraz().permiteAccesoAnubis() },
            generadorMensaje = { => "El polvo de los siglos consume a los mortales. Adopta la piel del Dios de los Muertos." }
        )
        game.addVisual(puertaVolver1)
        game.addVisual(puertaAnubis)
        if (!cartelYaMostrado) {
            game.addVisual(cartelPuertas)
            game.schedule(2000, { 
                if (game.hasVisual(cartelPuertas)) {
                    game.removeVisual(cartelPuertas)
                }
            })
            cartelYaMostrado = true
        }

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
        const puertaArtista = new Puerta(
            position = game.at(8, 4), 
            proximaSala = habitacionTres,
            posicionJugador = game.at(4, 2),
            condicionDePaso = {=> player.disfraz().permiteAccesoArtista() and administradorMarcos.puzzleResuelto()},
            generadorMensaje = { => 
                if (!administradorMarcos.puzzleResuelto()) {
                    "Las pinturas aún no están en orden."
                } else {
                    "El guardián de la galería exige que vistas como artista."
                }
            }
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
        const puertaFinal = new Puerta(
            position = game.at(5, 8), 
            proximaSala = habitacionFinal, 
            posicionJugador = game.at(5, 3),
            condicionDePaso = { => administradorEstatuas.estanTodasResueltas() and player.tiene(llave) },
            generadorMensaje = { => 
                if (!administradorEstatuas.estanTodasResueltas()) {
                    "Una magia bloquea la puerta. Resolvé el puzzle de estatuas."
                } else {
                    "Te olvidaste de la llave maestra!"
                }
            }
        )
        game.addVisual(puertaVolver2)
        game.addVisual(puertaFinal)

        administradorEstatuas.dibujarEstatuas()
    }
}  

object habitacionFinal {
    method dibujar(){
        game.addVisual(new Fondo(image = "ambientacion/habitacion_finalBueno.png"))
        game.addVisual(cartelReinicio)
        administradorDeSalas.juegoTerminado(true)
        game.schedule(1000, {
            game.say(player, "¡Logramos escapar!")
        })
        keyboard.r().onPressDo({ administradorDeSalas.reiniciar() })
    }
}

object pantallaDerrota {
    method position() = game.origin()
    method image() = "ambientacion/habitacion_finalMalo.png"
    
    method mostrar() {
        game.clear()            
        game.addVisual(self)
        administradorDeSalas.juegoTerminado(true)
        keyboard.r().onPressDo({ administradorDeSalas.reiniciar() })
        game.addVisual(cartelReinicio)
    }
}

object cartelReinicio {
    method position() = game.at(2, 2) 
    method text() = "Presiona la tecla R para reiniciar"
    method textColor() = "FFFF00FF" 
}