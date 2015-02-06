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

##### Heroku: https://batalla-naval-ttps-ruby.herokuapp.com/login
##### Integración Continua: https://travis-ci.org/JonathanLoscalzo/Batalla_Naval_TTPS_RUBY

###Acciones relacionadas con **jugadores**

####Crear un jugador
Petición
**POST /players HTTP/1.1**

Respuesta
*Status: 201 Created* 

En caso de error retornar un body que indique el error y el status: 
- Si el usuario ya existe: 409 Conflict 
- Si el nombre de usuario no es válido: 400 Bad request

La pantalla de inicio de sesión tiene 2 botones, uno para registro y otro para iniciar sesión.
Según cual se presione, es la acción a tomar. 
Crear un usuario involucra que el *username* no está repetido. 

####Listar jugadores
Petición
**GET /players HTTP/1.1**

Respuesta
*Status: 200 Ok*
Listar Jugadores se utiliza para listar los jugadores con los que se puede iniciar una partida. 
Para poder iniciar una partida, no tienen que existir partidas previas sin terminar.
Quizás se puede devolver un Json (y no un HTML).

###Acciones relacionadas con **partidas**

####Crear una partida
Petición
**POST /game/create HTTP/1.1**

Respuesta
*Status: 201 Created*

En caso de error retornar un body que indique el error y el status: 
- Si hay algún error de codificación: 400 Bad request

Para crear la partida, tiene que existir un id de usuario opositor. 
Quizás se pueda iniciar la partida luego de que el otro acepta.
(faltaria una opcion de listar partidas sin iniciar)

####Ver una partida
Petición
**GET /games/id_game**

Respuesta
La misma que POST /players/*id*/games pero con status 200

Puede devolver los datos de la partida en json. 
Solo se pueden ver partidas en juego.

####Listar partidas
Se lista en todas las pantallas. A la derecha una tabla cargada desde **get /games**

####Establecer la posición inicial de los barcos
Petición
**post '/games/:id_game'**

> Nota: Cada jugador deberá realizar esta acción antes de empezar a jugar, realizar esta acción más de una vez, o en un juego ya comenzado no debe alterar el tablero del juego.

Respuesta
*Status: 200 Ok*
*Body:* mismo que GET '/games/:id_game'

####Hacer una jugada
Petición
**put '/games/:id_game/move'**

Respuesta
*Status: 201 Created*
*Body:* mismo que GET '/games/:id_game'

Si no es el turno de este jugador porque el rival aún no hizo su jugada: 
*Status: 403 Forbidden*
*Body:* un mensaje de error descriptivo con el formato que está al final del documento.

###Errores

En caso que el servidor deba retornar un código de error HTTP, también deberá mostrar el error en la vista HTML del juego. ( el numero de error? o un error "visual")

En los casos de error que no estén especificados en este documento usar el status HTTP que sea más apropiado.


###Control de acceso

Los usuarios deben loguearse con contraseña.
Un usuario dado no debe poder ver ni usar el tablero de otro usuario.
La creación de usuarios se hace con el botón "registro" en la pantalla **/login**

###Pautas

El trabajo debe estar implementado con Sinatra, con vistas HTML y debe ser jugable.
El trabajo debe tener tests con una cobertura similar a la pedida en los parcialitos.
Los tests deben dar ok.
En los PUT y POST debería pasar la información necesaria para cada acción en el body de la petición.




