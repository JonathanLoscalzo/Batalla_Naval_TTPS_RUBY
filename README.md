#Trabajo práctico integrador
### Desarrollar un juego por turnos similar a la batalla naval usando Sinatra.

Al crear una partida, cada jugador deberá definir las posiciones de sus barcos en un tablero. Luego cada jugador podrá enviar un ataque intentando acertar a la posición de un barco enemigo para hundirlo.

El servidor deberá controlar los turnos para evitar que un jugador dado envíe un ataque si no es su turno

El jugador que crea la partida deberá indicar cual es su rival y el tamaño del tablero a usar: 
- 5x5
- 10x10
- 15x15.

> Nota: Para simplificar la implementación todos los barcos ocuparán una sola celda.

La cantidad de barcos de cada usuario dependerá del tamaño del tablero: 
- 5 * 5 -> 7
- 10 * 10 -> 15
- 15 * 15 -> 20


###Acciones relacionadas con **jugadores**

####Crear un jugador
Petición
**POST /players HTTP/1.1**

Respuesta
*Status: 201 Created* 

En caso de error retornar un body que indique el error y el status: 
- Si el usuario ya existe: 409 Conflict 
- Si el nombre de usuario no es válido: 400 Bad request

####Listar jugadores
Petición
**GET /players HTTP/1.1**

Respuesta
*Status: 200 Ok*

###Acciones relacionadas con **partidas**

####Crear una partida
Petición
** POST /players//games HTTP/1.1 **

Respuesta
*Status: 201 Created*

En caso de error retornar un body que indique el error y el status: 
- Si hay algún error de codificación: 400 Bad request

####Ver una partida
Petición
**GET /players/<id>/games/<id game>**

Respuesta
La misma que POST /players/<id>/games pero con status 200

####Listar partidas
Petición
**GET /players/<id>/games**

Respuesta
*Status: 200 Ok*

####Establecer la posición inicial de los barcos
Petición
**PUT /players/<id>/games/<id game>**

Nota: Cada jugador deberá realizar esta acción antes de empezar a jugar, realizar esta acción más de una vez, o en un juego ya comenzado no debe alterar el tablero del juego.

Respuesta
*Status: 200 Ok*
*Body:* mismo que GET /players/<id>/games/<id game>

####Hacer una jugada
Petición
**POST /players/<id>/games/<id game>/move**

Respuesta
*Status: 201 Created*
*Body:* mismo que GET /players/<id>/games/<id game>

Si no es el turno de este jugador porque el rival aún no hizo su jugada: 
*Status: 403 Forbidden*
*Body:* un mensaje de error descriptivo con el formato que está al final del documento.

###Errores

En caso que el servidor deba retornar un código de error HTTP, también deberá mostrar el error en la vista HTML del juego.

En los casos de error que no estén especificados en este documento usar el status HTTP que sea más apropiado.


###Control de acceso

Los usuarios deben loguearse con contraseña.
Un usuario dado no debe poder ver ni usar el tablero de otro usuario.


###Pautas

El trabajo debe estar implementado con Sinatra, con vistas HTML y debe ser jugable.
El trabajo debe tener tests con una cobertura similar a la pedida en los parcialitos.
Los tests deben dar ok.
En los PUT y POST debería pasar la información necesaria para cada acción en el body de la petición.



