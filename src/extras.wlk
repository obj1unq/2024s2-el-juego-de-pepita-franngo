import wollok.game.*
import pepita.*

object silvestre {
    const property esSolido = false

    method colisiono(personaje) { 
        personaje.perder()
    }

    //para silvestre, pepita no es pepita, sino que es simplemente una
    //presa. Es const porque la referencia es constante (no se la va
    //a cambiar por una referencia a otra cosa)
    const presa = pepita
    //como no hace falta inicializarlo en una cierta celda, sino que solo
    //imita la posición del otro, no hace falta que sea un atributo
    //postcálculo antes que precálculo (se puede deducir/calcular)
    method position() {
        return game.at(presa.position().x().max(3), 0)
    }

    method image() {
        return "silvestre.png"
    }

}

object nido {
    const property esSolido = false

    method colisiono(personaje) { 
        personaje.ganar()
    }

    method position() {
        return game.at(7,8)
    }

    method image() {
        return "nido.png"
    }

}

//cacharros nuevos

object tablero {
    const jugadora = pepita

    method validarDentro(posicion) {
        if(!self.estaDentro(posicion)) {
            //game.schedule(50, {game.stop()}) esto sería si quisieramos que el juego finalice al salirnos del mapa
            jugadora.error("el personaje está fuera del tablero")
        }
    }

    method estaDentro(posicion) {
        return posicion.x().between(0,game.width()-1) && posicion.y().between(0,game.height()-1)
    }
}

//para poder cambiar el fondo durante la partida y que no sea estático

object fondo {
    var escenario = 0

    method colisiono(personaje) { }
    
    method esSolido() {
        return false
    }

    method position() {
        return game.at(0,0)
    } 

    method image() {
        return "fondo" + escenario.toString() + ".jpg"
    }

    method cambiar() {
        escenario = (escenario + 1) % 2 //para alternar entre 2
    }

    //OTRA OPCIÓN
    //podemos hacer que, según donde está parada pepita, se devuelve el método image. para eso tenemos que evaluar la pos de pepita.
    //esto está buena para hacer que, cuando se pisa x lugar (como una celda con una puerta), se cambia el fondo

    //OTRA OPCIÓN
    //podemos hacer que dependa del estado de pepita cambiar el fondo cambiar el fondo
    /*
    method image() {
    return pepita.fondo()
    }

    y en pepita
    method fondo() {
        return estado.fondo()
    }

    y los objetos de estado posible de pepita deben entender todos el mensaje fondo() y devolver algo en concordancia
    */

}

object muro {
    const property esSolido = true

    //method colisiono(personaje) { } //nunca se llega a colisionar con el muro, así que es innecesario

    method position() {
        return game.at(3,3)
    }

     method image() {
        return "muro.png"
     }

}

object reloj {
    const property esSolido = false
    var segundos = 0
    
    method colisiono(personaje) { }

    method position() {
        return game.at(9,9)
    }

    method tick() {
        segundos += 1
    }

    method text() {
        return segundos.toString()
    }

    method textColor() {
        return "FFFF00"
    }
}



