import wollok.game.*
import posiciones.*
import extras.*

object pepita {

	var property isMoving = true //flag
	var property energia = 250
	var position = game.at(2,7);
	//lo ponemos como atributo porque tenemos que inicializarlo en una cierta celda!
	const cazador = silvestre
	
	method position() {
		return position
	}

	method image() {
		return "pepita" + self.estado().toString() + ".png"
	}

	method text() {
		return self.energia().toString() //método que entienden TODOS los objetos. Transforma a string.
	}

	method textColor() {
		return "FF0000" //primeras 2 posiciones indican el rojo, las siguientes 2 indican el verde y las 2 siguientes la transparencia
	}

	method comer(comida) {
		energia = energia + comida.energiaQueOtorga()
	}

	method comerAhi() {
		const comida = game.uniqueCollider(self) //si no hay un objeto con el que se está colisionando en ese momento, explota
		self.comer(comida)
		game.removeVisual(comida)
	}

	method mover(direccion) {
		self.validarMoverEnEstaDireccion(direccion) //como puede explotar, se ejecuta primero para evitar modificar el estado
		self.volar(1) //vuela si tenés la energia suficiente //NO explota porque, si no tenes energía para volar 1 una próxima vez,
					  //directamente comprobarFinDeJuego() se encarga de terminar el juego. aunque sí explota si tenés energía insuficiente
					  //sin haberte movido una primera vez (ponele, empezas con 5 de energía)
		position = direccion.siguiente(position)
		self.estado().comprobarFinDeJuego(self) //si estás en una situación de fin de juego (ganaste o perdiste), lo termina
												//tmb si no tenés energía suficiente para volar una próxima vez
	}

	method validarMoverEnEstaDireccion(direccion) {
		self.validarCapacidadMovimiento() //si ganaste (llegaste al nido) o perdiste (te agarró Silvestre), tira error
										  //sin embargo, es casi imposible que pase porque el comprobarFinDeJuego() termina el juego
										  //altoke al llegar a esas situaciones antes de que puedas intentar moverte de nuevo
										  //(y es directamente imposible con mi implementación del movimiento de pepita)
		const posSiguiente = direccion.siguiente(position)
		tablero.validarDentro(posSiguiente) //si la posición a la que te vas a mover se sale de los límites, no te deja moverte
		self.validarAtravesable(posSiguiente) //ahora tmb hay que validar que, a donde querés ir, no se una zona imposible de atravesar
	}

	method validarCapacidadMovimiento() {
		if(!self.estado().puedeMover()) {
			self.error("El personaje no puede realizar movimientos")
		}
	}

	method volar(kms) {
		self.validarVolar(1)
		energia = energia - self.energiaGastadaAlVolar(kms)
	}

	method validarVolar(kms) {
		if(!self.puedeVolar(kms)) {
			self.error("No hay suficiente energía para volar " + kms + "km")
		}
	}

	method energiaGastadaAlVolar(kms) {
		return 10 + kms
	}

	method puedeVolar(kms) { //método booleano QUE NO ES LO MISMO que la validación
		return energia >= self.energiaGastadaAlVolar(kms)
	}

	method estado() {
		return if (self.estaEnNido()) {
			return victoriosa
		} else if (self.estaMuerta()) {
			return muerta
		} else {
			return viva
		}
	}

	method estaMuerta() {
		return !self.puedeVolar(1) || self.estaAtrapada()
	}

	method estaEnNido() {
		return position==game.at(7,8)
	}

	method estaAtrapada() {
		return position==cazador.position()
	}

	//otra forma de hacerlo es tener atributo que te dice en qué estado está el pj porque no siempre es fácil calcularlo
	//este cambiaría cuando suceden cierto eventos, como la colisión con x o y objeto

	method validarAtravesable(posSiguiente) { //esto podría ir como método de tablero sino
		if(self.hayAlgoSolido(posSiguiente)) {
			self.error("no se puede ir ahí debido a la presencia de algo que impide el paso")
		}
	}

	method hayAlgoSolido(posSiguiente) {
		const objs = game.getObjectsIn(posSiguiente)
		return objs.any({obj => obj.esSolido()}) //por ende, cada objeto que tenga una pos y una imagen (o sea, con el que se puede
												 //colisionar), debe comprender esSolido()
	}

	method caer() {
		self.validarMoverEnEstaDireccion(abajo)
		position = game.at(self.position().x(), self.position().y()-1)
	}

}

//estados

object viva {
	const property puedeMover = true

	method comprobarFinDeJuego(personaje) { }
}

object muerta {
	const property puedeMover = false

	method comprobarFinDeJuego(personaje) {
		game.say(personaje, "Perdí")
		game.schedule(50, {game.stop()})
	}
}

object victoriosa {
	const property puedeMover = false

	method comprobarFinDeJuego(personaje) {
		game.say(personaje, "Gané")
		game.schedule(50, {game.stop()})
	}
}

//podés hacer cosas como que, según el estado en el que estás, el comportamiento de tu personaje va a variar 
//profe da ejemplo de, según tu estado, los disparon son más débiles

