require 'bundler'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir['./models/**/*.rb'].each {|f| require f } # => requiero todos los archivos en models/*.rb
#Dir['./controllers/**/*.rb'].each {|f| require f } 
Dir['./helpers/**/*.rb'].each {|f| require f }

class Application < Sinatra::Base
	#__________________extensiones__________________
	register Sinatra::ActiveRecordExtension
	register Sinatra::SessionHelper
	register Sinatra::UrlHelper
	register Sinatra::BoardHelper
	#__________________configuraciones__________________
	configure do
		use Rack::Session::Pool # => por algun motivo, con enable :session no funcionaba.
		set :session_secret, 'super secret'
	end

	configure :development do
		enable :show_exceptions
		use BetterErrors::Middleware
 		BetterErrors.application_root = __dir__
 		#enable :logging
	end

	set :database, YAML.load_file('config/database.yml')[ENV['RACK_ENV']]

	set :method_override, true

	#__________________Comportamiento__________________
	get '/login' do
		erb 'login/login'.to_sym 
	end

	get '/logout' do
		logout!
		redirect '/login'
	end

	post '/login' do
	#Route para iniciar sesion. Si algun dato llega vacio o no llega se devuelve status 400
		unless has_params_keys?(params, 'username', 'password')
			login username:params['username'], password:params['password']
		else 
			response.status=400
			session[:message] = { :value => "Hubo un error en los datos. Intente nuevamente", :type => "info" }
		end
		erb 'login/login'.to_sym
	end

	get '/sizes', :auth => nil do
	# Listar jugadores (con los que se puede jugar iniciar partida)
		sizes = Breed.all
		content_type :json
		sizes.as_json(only: [:id, :size, :count_ships]).to_json
	end

	get '/turn/:id_game', :auth => nil do |id_game|
	# Listar jugadores (con los que se puede jugar iniciar partida)
		if(Game.find(id_game).user_can_play?(actual_user_id))
			return 200	
		end
		return 400
	end

	post '/players' do
	#Crear un Jugador. datos entrada username y password.
		unless has_params_keys? params, 'username', 'password'
			username = params['username']
			password = params['password']
			user = User.where(username: username)
			if user.empty?
				user = User.create do | u |
					u.username = username
					u.password = password
				end
				session[:message]= { :value => "Creado Correctamente", :type => "success" }
			else
				status 409
				session[:message]= { :value => "El Usuario "+ username +" ya existe.", :type => "danger" }
			end
		else
			status 400
			session[:message]= { :value => "Datos Erronéos", :type => "danger" }
		end
		erb 'login/login'.to_sym
	end

	get '/players', :auth => nil do
	# Listar jugadores (con los que se puede jugar iniciar partida)
		user_id = session[:user_id]
		players = User.where(["id <> :id", { id: user_id }]).select(:id,:username)
		content_type :json
		players.to_json # => only: [:id, :username]
	end

	get '/games', :auth => nil do
		#devuelve todos los juegos (los datos necesarios para la tabla)
		#content-type : json
		# => cambiar la forma de devolver los datos. Ahora board tiene usuarios

		games = Game.all
		content_type :json
		games.to_a.map do |e| 
			e.as_json include: [
				{ board1: { 
					include:[{
						user: {
							only:[:id, :username]
						}
					}],
					only: [:id, :user]
					}
				}, 
				{ board2: { 
					include: [{
						user: {
							only:[:id, :username]
						}
					}],
					only: [:id, :user]
					} 
				}, 
				{ status: { 
					only: :description 
					}
				}],
				only: [:id,:board1,:board2,:status]
		end.to_json

	end

	get '/games/create/:id_user', :auth => nil do |id_user|
		#Para crear partidas. id_user es el contrario.
		if User.exists?(id_user)
			erb 'game/create'.to_sym 
		else
			status 409
			session[:message]= { :value => "No se puede crear un juego con un usuario que no existe", :type => "danger" }
			erb 'login/login'.to_sym
		end		
	end

	post '/game/create', :auth=> nil do
	#Crear una partida entre usuario de la sesion y jugador enviado.
		unless has_params_keys? params, 'user_id', 'select-size'
			user_id = params['user_id']
			breed_id = params['select-size']
			breed = Breed.find(breed_id)
			board2 = Board.create(breed:breed, user:User.find(user_id))
			board1 = Board.create(breed:breed, user:User.find(session[:user_id])) # => user1 es el de la session.
			game = Game.create(board1:board1, board2: board2)
			game.save
			response.status=201
			dir='/games/' + game.id.to_s
		else
			session[:message] = { :value => "Problemas recibiendo datos, intente nuevamente! ", :type => "warning" }
			response.status=409
			dir = '/login'
		end
		redirect dir, 303
	end

	post '/games/:id_game', :auth => nil do |id_game|
		# El usuario actual envia su tablero con barcos. No puede enviar 2 veces
		# la partida tiene que ser propia
		unless has_params_keys? params, 'ships-position'
			game = Game.find(id_game)
			if game.user_in_game?(actual_user_id)
				if game.status.id == 1
					# => si el usuario està en el juego, y el juego està iniciado
					board = game.get_board_from_user(actual_user_id)
					count_ships = board.breed.count_ships
					if(params['ships-position'].length == board.breed.count_ships)
						(1..count_ships).each.with_index do |column, x|
							if(!params['ships-position'][x].nil?)
								pos = params['ships-position'][x].split("-")
								ship = Ship.create(x:pos[0],y:pos[1],board:board,sunken:false)
								board.add_ship(ship) 
							end
						end
						board.ready_for_play
						if game.ready_for_play?
							game.play
						end
					else
						# => si el usuario està en el juego, pero ya enviaron los 2 tableros.
						status 409
						session[:message] = { :value => "Enviaste menos ships de los necesarios", :type => "danger" }		
					end
				else
					# => si el usuario està en el juego, pero ya enviaron los 2 tableros.
					status 409 # => que mensaje devolver?
					session[:message] = { :value => "No se puede reenviar el tablero mientras se está jugando", :type => "danger" }
				end
			else
				status 409 # => que mensaje devolver?
				session[:message] = { :value => "El Usuario #{actual_user} no está jugando el juego con id:#{id_game}", :type => "danger" }
			end
		else
			status 400 # => que mensaje devolver?
			session[:message] = { :value => "Problemas recibiendo coordenadas, intente nuevamente! ", :type => "warning" }
		end
		redirect '/games/' + game.id.to_s
	end

	put '/games/:id_game/move', :auth => nil do |id_game|
		# se recibe posiciones x,y. 
		unless has_params_keys? params, 'column', 'row'
			column = params["column"].to_i 
			row = params["row"].to_i 
			# => primero valido que sea su juego y su turno
			game = Game.find(id_game)
			if game.user_in_game? actual_user_id
				if game.user_turn.id == actual_user_id
					# => si es el turno del usuario. Hace el disparo.
					session[:message] = game.shot_to(column: column, row: row, user_id:actual_user_id)
					game.finish?
					redirect '/games/'+id_game.to_s # => este sabe si se termino el juego o no.
				else
					status 409 
					session[:message] = { :value => "No es tu turno!", :type => "danger" }
					redirect '/games/'+ id_game.to_s
				end
			else
				status 409 
				session[:message] = { :value => "El Usuario #{actual_user} no está jugando el juego con id:#{id_game}", :type => "danger" }
				redirect '/login'
			end
		else
			status 400 
			session[:message] = { :value => "Error recibiendo disparo, intente nuevamente!", :type => "warning" }
			redirect '/games/'+ id_game.to_s
		end


	end

	delete '/games/:id_game', :auth => nil do |id_game|
		# Termina la partida. Gana automaticamente el otro
		# Todos los barcos propios mueren ? 

#		game = Game.find(id_game)
#		uri = ""
#		hash_message = ""
#		if game
#			if game.user_in_game? actual_user_id
#				case game.status
#				when 2
#					board = game.get_board_from_user(actual_user_id)
#					#board.ships.update_all 
#					board.ships.map { |s| s.update(sunken: true) }
#					hash_message = { :value => "Abandonó el juego", :type => "info" }
#				else
#					game.destroy
#					hash_message = { :value => "El juego con id #{id_game} a sino eliminado", :type => "info" }
#				end
#			else
#				hash_message = { :value => "Ud no puede eliminar el juego.", :type => "danger" }
#			end
#		else
#			session[:message] = { :value => "El juego con id #{id_game} no existe.", :type => "info" }
#		end
#		session[:message] = hash_message
#		erb uri.to_sym
	end

	get '/games/:id_game', :auth => nil do |id_game|
		#-> si es propia
		#	-> estado iniciado : tablero para completar y enviar (cambia el tablero)
		#	-> jugando : tablero propio y disparos sobre mi tablero. Tablero contrario y
		# 		posibilidad de elegir donde disparar.
		#	-> cancelada o terminada : se puede ver ambos tableros y quien gano.
		#-> si no es propia (ambas opciones son iguales)
		#	-> se ven ambos tableros. 
		#	-> si està terminada dice quien ganò, sino solo se muestran las jugadas.
		# SUPONGO debe ser el mismo template...
		# para el tablero, usar un template: de knockout
		if Game.exists?id_game
			@game = Game.find(id_game)
			uri = ""
			if(@game.user_is_playing?(actual_user_id))
				case @game.status.id
				when 1
					if(@game.user_can_play?(actual_user_id))
						uri = 'playing'
					else
						if(@game.ready_for_play(actual_user_id))
							uri = 'waiting'
						else
							uri = 'play'
						end
					end
				when 2
					if(@game.user_can_play?(actual_user_id))
						session[:message] =  { :value => "Your turn", :type => "success" }
						uri = 'playing'
					else
						uri = 'waiting'
					end
				when 3
					if(actual_user_id == @game.who_wins?.id)
						session[:message] =  { :value => "You win!!", :type => "success" }
					else
						session[:message] =  { :value => "You lose", :type => "danger" }
					end
					uri = 'showgame'
				end
			else
				uri = 'showgame'
			end
			erb ('game/'+uri).to_sym
		else
			session[:message] =  { :value => "Ese game no existe", :type => "info" }
			response.status=400
			redirect '/login'
		end
	end

   not_found do	
		erb :'page_404', :layout => false
	end
private
	def has_params_keys?(params, *args)
		args.detect(nil) { |e| ! ((params.key? e) && !params[e].empty?) }
	end

end
