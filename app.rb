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
		login username:params['username'], password:params['password']
		erb 'login/login'.to_sym
	end

	get '/sizes', :auth => nil do
	# Listar jugadores (con los que se puede jugar iniciar partida)
		sizes = Breed.all
		content_type :json
		sizes.to_json
	end

	post '/players' do
	#Crear un Jugador. datos entrada username y password.
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
=begin
		games = Game.all
		content_type :json
		games.to_a.map do |e| 
			e.as_json include: [
				{ board1: { only: [:id, :username]} }, 
				{ board1: { only: [:id, :username]} }, 
				{ status: { only: :description }}],
				only: [:id,:user1,:user2,:status]
		end.to_json
=end
	end

	get '/games/create/:id_user', :auth => nil do |id_user|
		#Para crear partidas. id_user es el contrario. Verifica que no haya otras partidas entre ellos.
		erb 'game/create'.to_sym
	end

	post '/game/create' do
	#Crear una partida entre usuario de la sesion y jugador enviado.
		user_id = params['user_id']
		size = params['select_size']
		breed = Breed.where(size:size).first
		board1 = Board.create(breed:breed, user:User.find(user_id))
		board2 = Board.create(breed:breed, user:User.find(session[:user_id]))
		game = Game.create(board1:board1, board2: board2)
		game.save
		redirect '/games/' + game.id.to_s
	end

	post '/games/:id_game', :auth => nil do |id_game|
		# El usuario actual envia su tablero con barcos. No puede enviar 2 veces
		# la partida tiene que ser propia
		game = Game.find(id_game)
		if game.user_in_game?(actual_user_id)
			if game.status.id == 1
				# => si el usuario està en el juego, y el juego està iniciado
				board = game.get_board_from_user(actual_user_id)
				count_ships = board.breed.count_ships
				(1..count_ships).each.with_index do |column, x|
					pos = params['ships-position'][x].split("-")
					board.add_ship(Ship.create(x:pos[0],y:pos[1],board:board)) 
				end
				game.play
				redirect '/games/' + game.id.to_s
			else
				# => si el usuario està en el juego, pero ya enviaron los 2 tableros.
				status 409 # => que mensaje devolver?
				session[:message] = { :value => "No se puede reenviar el tablero mientras se está jugando", :type => "danger" }
			end
		else
			status 409 # => que mensaje devolver?
			session[:message] = { :value => "El Usuario #{actual_user} no está jugando el juego con id:#{id_game}", :type => "danger" }
		end


	end

	put '/games/:id_game/move', :auth => nil do |id_game|
		# se recibe posiciones x,y. 
		# solo puede mover si es su turno y si el juego està en iniciado FALTA ESTO!

		column = params["column"].to_i
		row = params["row"].to_i
		# => primero valido que sea su juego y su turno
		game = Game.find(id_game)
		if game.user_in_game? actual_user_id
			if game.user_turn.id == actual_user_id
				# => si es el turno del usuario. Hace el disparo. 
				session[:message] = game.shot_to(column: column, row: row, user_id:actual_user_id)
				game.finish?
				redirect '/pulir' # => este sabe si se termino el juego o no.
			else
				status 409 # => que mensaje devolver?
				session[:message] = { :value => "No es tu turno!", :type => "danger" }
				redirect '/games/'+ id_game.to_s
			end
		else
			status 409 # => que mensaje devolver?
			session[:message] = { :value => "El Usuario #{actual_user} no está jugando el juego con id:#{id_game}", :type => "danger" }
			redirect '/login'
		end


	end

	delete '/games/:id_game', :auth => nil do |id_game|
		# Termina la partida. Gana automaticamente el otro
		# Todos los barcos propios mueren ? 
		#  
	end

	get '/games/:id_game' do |id_game|
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
		@game = Game.find(id_game)
		puts @game.status.id
		puts "----------------------------------------------------------ssadsd"
		if(@game.status.id == 2)
				erb 'game/playing'.to_sym
			else
				erb 'game/play'.to_sym
		end
	end

	get '/pulir' do
		erb '/game/prueba_put'.to_sym
	end

#   not_found do	
#		erb :'page_404', :layout => false
#	end
end
