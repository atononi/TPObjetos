// Destinos
class Destino{
	var property precio
	const property equipaje
		
	method destinoDestacado(){
		return self.precio() > 2000
	}
	
	method aplicarDescuento(descuento){
		precio = precio*(1-(descuento/100))
		equipaje.add("Certificado de Descuento")
	}
	
	method esPeligroso(){
		return equipaje.any({objecto => objecto.startsWith("Vacuna")})
	}
}


const garlicSea = new Destino(
	precio = 2500,
	equipaje = ["Cania de pescar", "Piloto"]
)

const silverSea = new Destino(
	precio = 1350,
	equipaje = ["rotector Solar", "Equipo de Buceo"]
)

const lastToninas = new Destino(
	precio = 3500,
	equipaje = ["Vacuna Gripal", "Vacuna B", "Necronomicon"]
)

const goodAirs = new Destino(
	precio = 1500,
	equipaje = ["Cerveza", "Protector Solar"]
)

// Barrilete Cosmico
object barrileteCosmico{
	var property origen
	var property destino
	const property mediosTransporte = [avion, micro]
	var property transporte
	
	method nuevoUsuario(unUsuario){
		usuario = unUsuario
	}
	
	method armarViaje(usuario, nuevoDestino){
		origen = usuario.localidadOrigen()
		destino = nuevoDestino
		transporte = mediosTransporte.anyOne() 
		
		return new Viaje(origen=origen,destino=destino,transporte=transporte)
	}
	
}

// Usuarios
class Usuario {
	var property nombreUsuario
	const property viajes
	const property following = []
	var property cuenta
	var property localidadOrigen
	var property lugaresConocidos
	
	method viajarA(destino){
		if(destino.precio() < cuenta){
			lugaresConocidos.add(destino)
			cuenta -= destino.precio()
			localidadOrigen = destino
		}
	}
	
	method obtenerKilometros(){
		return viajes.sum({ viaje => viaje.distanciaLocalidades() })
	}
	
	method seguirA(unUsuario){
		following.add(unUsuario.nombreUsuario())
		unUsuario.following().add(nombreUsuario)
	}
}

// Localidades
class Localidad inherits Destino {
	var property ubicacion 
	
	method distanciaEntre(otroLugar){
		return (ubicacion - otroLugar.ubicacion()).abs()
	}
}


class MedioDeTransporte {
	var property duracionTrayecto
	var property costoPorKilometro
}


class Viaje {
	var property origen
	var property destino
	var property transporte
	var property valorKm = 0
	
	method valorKm(){
		var valor 
		valor = origen.distanciaEntre(destino) * transporte.costoPorKilometro()
		return valor
	}
	
	method precioViaje(){
		return (self.valorKm() + destino.precio())
	}
	
	method distanciaLocalidades(){
		return origen.distanciaEntre(destino)
	}
}



const buenosAires = new Localidad(
	ubicacion = 100,
	precio = 40000,
	equipaje = []
)

const bariloche = new Localidad(
	ubicacion = 275,
	precio = 65000,
	equipaje = []
)

const laRioja = new Localidad(
	ubicacion = 95,
	precio = 25000,
	equipaje = []
)

const avion = new MedioDeTransporte(
	duracionTrayecto = 9000,
	costoPorKilometro = 750
)

const micro = new MedioDeTransporte(
	duracionTrayecto = 259200,
	costoPorKilometro = 350
)


const viajeAlSur = new Viaje(
	origen = buenosAires,
	destino = bariloche,
	transporte = avion
)


const pepe = new Usuario(
	nombreUsuario = "Pepe",
	viajes = [viajeAlSur],
	cuenta = 50000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [bariloche]
)



