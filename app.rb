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
		players = User.all.select(:id,:username)
		content_type :json
		players.to_json # => only: [:id, :username]
	end

	get '/games' do
		#devuelve todos los juegos (los datos necesarios para la tabla)
		#content-type : json
		games = Game.all
		content_type :json
		games.to_a.map do |e| 
			e.as_json include: [
				{ user1: { only: [:id, :username]} }, 
				{ user2: { only: [:id, :username]} }, 
				{ status: { only: :description }}],
				only: [:id,:user1,:user2,:status]
		end.to_json
	end

	post '/games/:id_user', :auth => nil do |id_user|
		#Para crear partidas. id_user es el contrario. Verifica que no haya otras partidas entre ellos.
		# 
	end

	put '/games/:id_game', :auth => nil do |id_game|
		# El usuario actual envia su tablero con barcos. No puede enviar 2 veces
		# la partida tiene que ser propia
	end

	put '/games/:id_game/move', :auth => nil do |id_game|
		# se recibe posiciones x,y. 
		# solo puede mover si es su turno y si el juego està en iniciado
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
		@game		
	end

#   not_found do	
#		erb :'page_404', :layout => false
#	end
end
