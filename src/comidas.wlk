import wollok.game.*

object manzana {
	const property esSolido = false
    method position() {
        return game.at(1,1)
    }

    method image() {
        return "manzana.png"
    }

	method energiaQueOtorga() {
		return 5
	}
}

object alpiste {
	const property esSolido = false
    method position() {
        return game.at(6,6)
    }

    method image() {
        return "alpiste.png"
    }

	method energiaQueOtorga() {
		return 20
	}
}

//falta la energia que otorga
