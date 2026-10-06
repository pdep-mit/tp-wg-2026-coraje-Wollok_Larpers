import wollok.game.*

object administradorDeSalas {
    method iniciar() {
        self.cambiarA(salaPrincipal)
    }

    method cambiarA(nuevaSala) {
        game.clear()
        nuevaSala.dibujar()
    }
}
object salaPrincipal {
    method dibujar() {
        game.boardGround ("habitacion_cero.png")
        }
}

object habitacionUno {
    method dibujar() {
        game.boardGround ("habitacion_uno.png")
    }
}