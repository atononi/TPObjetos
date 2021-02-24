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


// Usuarios
class Usuario {
	var property nombreUsuario
	const property viajes
	const property following = []
	var property cuenta
	var property localidadOrigen
	var property lugaresConocidos
	var property perfil
	
	method viajarA(destino){
		if(destino.precio() > cuenta){
			throw new Exception(message='No tiene la plata suficiente')
		}
		lugaresConocidos.add(destino)
		cuenta -= destino.precio()
		localidadOrigen = destino
	}
	
	method obtenerKilometros(){
		return viajes.sum({ viaje => viaje.distanciaLocalidades() })
	}
	
	method seguirA(unUsuario){
		following.add(unUsuario.nombreUsuario())
		unUsuario.following().add(nombreUsuario)
	}
	
	method perfil(nuevoPerfil){
		perfil = nuevoPerfil
	}
}

class Estudiantil{
	method obtenerKms(usuario, nuevoDestino){
		return (usuario.localidadOrigen().ubicacion() - nuevoDestino.ubicacion()).abs()
	}

	method transporteDisponible(usuario, nuevoDestino, mediosTransporte){
		var mediosBaratos
		var kms = self.obtenerKms(usuario, nuevoDestino)
		mediosBaratos = mediosTransporte.filter({medioT => medioT.costoPorKm()*kms < usuario.cuenta() })
		if(mediosBaratos == []){
			throw new Exception(message='No tiene plata costearse ningun transporte')
		}
		return mediosBaratos.max({medioT=>medioT.velocidad()})
		}
}

class Empresarial{
	method transporteDisponible(usuario, nuevoDestino, mediosTransporte){
		return mediosTransporte.max({medioT=>medioT.velocidad() })
	}
}

class Familiar{
	method transporteDisponible(usuario, nuevoDestino, mediosTransporte){
		return mediosTransporte.anyOne()
	}
}

// Localidades
class Localidad inherits Destino {
	var property ubicacion 
	var property cualidad
	
	method distanciaEntre(otroLugar){
		return (ubicacion - otroLugar.ubicacion()).abs()
	}
	
}

class Playa inherits Localidad {
	override method esPeligroso(){
		return false
	}
	override method destinoDestacado(){
		return false
	}
}
class Montania inherits Localidad {
	override method esPeligroso(){
		return (equipaje.any({objecto => objecto.startsWith("Vacuna")}) and cualidad > 5000)
	}
	override method destinoDestacado(){
		return true
	}
}
class CiudadHistorica inherits Localidad {
	override method esPeligroso(){
		return not(equipaje.any({objecto => objecto.startsWith("Asistencia")}))
	}
	override method destinoDestacado(){
		return (precio>2000 and cualidad.size() > 3)
	}
}


class MedioDeTransporte {
	var property duracionTrayecto
	var property cualidad 
	var property velocidad
}

class Micro inherits MedioDeTransporte {
	method costoPorKm(){
		return 500
	}
}
class Tren inherits MedioDeTransporte {
	method costoPorKm(){
		return 1429
	}
}
class Avion inherits MedioDeTransporte {
	method costoPorKm(){
		return cualidad.sum()
	}
}
class Barco inherits MedioDeTransporte {
	method costoPorKm(){
		return cualidad * 1000
	}
}


class Viaje {
	var property origen
	var property destino
	var property transporte
	var property valorKm = 0
	
	method valorKm(){
		var valor 
		valor = origen.distanciaEntre(destino) * transporte.costoPorKm()
		return valor
	}
	
	method precioViaje(){
		return (self.valorKm() + destino.precio())
	}
	
	method distanciaLocalidades(){
		return origen.distanciaEntre(destino)
	}
}



const marDelPlata = new Playa(
	ubicacion = 100,
	precio = 40000,
	equipaje = [],
	cualidad = []
)

const bariloche = new Montania(
	ubicacion = 275,
	precio = 65000,
	equipaje = ['Vacuna'],
	cualidad = 5250
)

const laRioja = new Montania(
	ubicacion = 340,
	precio = 30000,
	equipaje = ['Vacuna'],
	cualidad = 4000
)

const buenosAires = new CiudadHistorica(
	ubicacion = 95,
	precio = 70000,
	equipaje = ['Asistencia al viajero'],
	cualidad = ['bellasArtes','malba','naturales','usina']
)

const tucuman = new CiudadHistorica(
	ubicacion = 125,
	precio = 25000,
	equipaje = ['Asistencia al viajero'],
	cualidad = ['casaIndependencia']
)

const montevideo = new Playa(
	ubicacion = 245,
	precio = 85000,
	equipaje = [],
	cualidad = []
)

const avion = new Avion(
	duracionTrayecto = 9000,
	velocidad = 400,
	cualidad = [350,350]
)

const micro = new Micro(
	duracionTrayecto = 259200,
	velocidad = 140,
	cualidad = []
)

const barco = new Barco(
	duracionTrayecto = 432000,
	velocidad = 213, // nudos pasados a km
	cualidad = 25
)

const tren = new Tren(
	duracionTrayecto = 216000,
	velocidad = 135,
	cualidad = []
)

const viajeAlSur = new Viaje(
	origen = buenosAires,
	destino = bariloche,
	transporte = avion
)

const viajeAmdp = new Viaje(
	origen = buenosAires,
	destino = marDelPlata,
	transporte = micro
)

const delNorteAlSur = new Viaje(
	origen = tucuman,
	destino = bariloche,
	transporte = micro
)

const trenAmdp = new Viaje(
	origen = buenosAires,
	destino = marDelPlata,
	transporte = tren
)

const buquebus = new Viaje(
	origen = buenosAires,
	destino = montevideo,
	transporte = barco
)



const pepe = new Usuario(
	nombreUsuario = "Pepe",
	viajes = [viajeAlSur, delNorteAlSur],
	cuenta = 165000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [bariloche, laRioja],
	perfil = new Empresarial()
)

const felipe = new Usuario(
	nombreUsuario = "Felipe",
	viajes = [buquebus],
	cuenta = 2000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [],
	perfil = new Estudiantil()
)

const gutierrez = new Usuario(
	nombreUsuario = "Guti",
	viajes = [viajeAmdp],
	cuenta = 120000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [],
	perfil = new Familiar()
)

