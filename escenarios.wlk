import wollok.game.*

class Muro {
    var property position
    var property image
}
class Piso {
    var property position
    var property image
}
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
        const ancho = game.width()
        const alto = game.height()
    
        (1 .. ancho - 2).forEach({ x =>
            (1 .. alto - 2).forEach({ y =>
                game.addVisual(new Piso(position = game.at(x, y), image = "piso_principal.png"))
            })
        })

        (0 .. ancho - 1).forEach({ x =>
            game.addVisual(new Muro(position = game.at(x, 0), image = "muro_principal.png"))
            game.addVisual(new Muro(position = game.at(x, alto - 1), image = "muro_principal.png"))
        })
        (1 .. alto - 2).forEach({ y =>
            game.addVisual(new Muro(position = game.at(0, y), image = "muro_principal.png"))
            game.addVisual(new Muro(position = game.at(ancho - 1, y), image = "muro_principal.png"))
        })
    }
}
object habitacionUno {
    method dibujar() {
        const ancho = game.width()
        const alto = game.height()
        
        (1 .. ancho - 2).forEach({ x =>
            (1 .. alto - 2).forEach({ y =>
                game.addVisual(new Piso(position = game.at(x, y), image = "piso_1.png"))
            })
        })

        (0 .. ancho - 1).forEach({ x =>
            game.addVisual(new Muro(position = game.at(x, 0), image = "muro_1.png"))
            game.addVisual(new Muro(position = game.at(x, alto - 1), image = "muro_1.png"))
        })
        (1 .. alto - 2).forEach({ y =>
            game.addVisual(new Muro(position = game.at(0, y), image = "muro_1.png"))
            game.addVisual(new Muro(position = game.at(ancho - 1, y), image = "muro_1.png"))
        })
    }
}