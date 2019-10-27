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
	const property mediosTransporte = [avion, micro, tren, barco]
	var property transporte
	
	method elegirTransporte(usuario, nuevoDestino){
		if(usuario.perfil()=='estudiantil'){
			var mediosBaratos
			var kms = (usuario.localidadOrigen().ubicacion() - nuevoDestino.ubicacion()).abs()
			mediosBaratos = mediosTransporte.filter({medioT => medioT.costoPorKilometro()*kms < usuario.cuenta() })
			if(mediosBaratos == []){
				throw new Exception(message='No tiene plata costearse ningun transporte')
			}
			return mediosBaratos.max({medioT=>medioT.velocidad()})
			}
		
		if(usuario.perfil()=='empresarial'){
			return mediosTransporte.max({medioT=>medioT.velocidad() })
		}
		return mediosTransporte.anyOne()
	}
	
	method armarViaje(usuario, nuevoDestino){
		origen = usuario.localidadOrigen()
		destino = nuevoDestino
		transporte = self.elegirTransporte(usuario, nuevoDestino)
		
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
	
	method cambiarPerfil(nuevoPerfil){
		perfil = nuevoPerfil
	}
}


// Localidades
class Localidad inherits Destino {
	var property ubicacion 
	var property tipo
	var property cualidad
	
	method distanciaEntre(otroLugar){
		return (ubicacion - otroLugar.ubicacion()).abs()
	}
	
	override method esPeligroso(){
		if(tipo=='playa'){
			return false
		}
		if(tipo=='montania'){
			return (equipaje.any({objecto => objecto.startsWith("Vacuna")}) and cualidad > 5000)
		}
		if(tipo=='ciudadHistorica'){
			return not(equipaje.any({objecto => objecto.startsWith("Asistencia")}))
		}
		return false
	}
	
	override method destinoDestacado(){
		if(tipo=='ciudadHistorica'){
			return (precio>2000 and cualidad.size() > 3)
		}
		if(tipo=='montania'){
			return true
		}
		return false
	}
	
}


class MedioDeTransporte {
	var property duracionTrayecto
	var property medio
	var property cualidad 
	var property velocidad
	
	
	method costoPorKilometro(){
		if(medio=='micro'){
			return 5000
		}
		if(medio=='tren'){
			return 1429
		}
		if(medio=='avion'){
			return cualidad.sum()
		}
		if(medio=='barco'){
			return cualidad * 1000
		}
		return 0
	}
	
	
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



const marDelPlata = new Localidad(
	ubicacion = 100,
	precio = 40000,
	equipaje = [],
	tipo = 'playa',
	cualidad = []
)

const bariloche = new Localidad(
	ubicacion = 275,
	precio = 65000,
	equipaje = ['Vacuna'],
	tipo = 'montania',
	cualidad = 5250
)

const laRioja = new Localidad(
	ubicacion = 340,
	precio = 30000,
	equipaje = ['Vacuna'],
	tipo = 'montania',
	cualidad = 4000
)

const buenosAires = new Localidad(
	ubicacion = 95,
	precio = 70000,
	equipaje = ['Asistencia al viajero'],
	tipo = 'ciudadHistorica',
	cualidad = ['bellasArtes','malba','naturales','usina']
)

const tucuman = new Localidad(
	ubicacion = 125,
	precio = 25000,
	equipaje = ['Asistencia al viajero'],
	tipo = 'ciudadHistorica',
	cualidad = ['casaIndependencia']
)

const montevideo = new Localidad(
	ubicacion = 245,
	precio = 85000,
	equipaje = [],
	tipo = 'playa',
	cualidad = []
)

const avion = new MedioDeTransporte(
	duracionTrayecto = 9000,
	medio = 'avion',
	velocidad = 400,
	cualidad = [350,350]
)

const micro = new MedioDeTransporte(
	duracionTrayecto = 259200,
	medio = 'micro',
	velocidad = 140,
	cualidad = []
)

const barco = new MedioDeTransporte(
	duracionTrayecto = 432000,
	medio = 'barco',
	velocidad = 213, // nudos pasados a km
	cualidad = 25
)

const tren = new MedioDeTransporte(
	duracionTrayecto = 216000,
	medio = 'tren',
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
	perfil = 'empresarial'
)

const felipe = new Usuario(
	nombreUsuario = "Felipe",
	viajes = [buquebus],
	cuenta = 2000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [],
	perfil = 'estudiantil'
)

const gutierrez = new Usuario(
	nombreUsuario = "Guti",
	viajes = [viajeAmdp],
	cuenta = 120000,
	localidadOrigen = buenosAires,
	lugaresConocidos = [],
	perfil = 'familiar'
)

