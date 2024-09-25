import wollok.game.*

object arriba {
    
    method siguiente(posicion) {
        return posicion.up(1)
    }

}

object derecha {
    
    method siguiente(posicion) {
        return posicion.right(1)
    }

}

object abajo {
    
    method siguiente(posicion) {
        return posicion.down(1)
    }

}

object izquierda {
    
    method siguiente(posicion) {
        return posicion.left(1)
    }

}


