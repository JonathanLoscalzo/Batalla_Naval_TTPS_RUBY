require 'bundler'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir['./models/**/*.rb'].each {|f| require f } # => requiero todos los archivos en models/*.rb
# Dir['./controllers/**/*.rb'].each {|f| require f } 
Dir['./helpers/**/*.rb'].each {|f| require f }

class Application < Sinatra::Base
	#__________________extensiones__________________
	register Sinatra::ActiveRecordExtension
	register Sinatra::SessionHelper # => con helpers no funciona.

	#__________________configuraciones__________________
	configure do
		enable :sessions
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

	post '/login' do
		username = params['username']
		password = params['password']
		user = User.where(username:username.to_s, password:password.to_s).first
		if user
			p user.username, user.password
		else
			p 'no hay nadie'
		end
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
		else
			status 409
			session[:mensaje]= { :value => "El Usuario "+ username +" ya existe.", :type => "danger" }
		end
		erb 'login/login'.to_sym
	end

	get '/players', :auth => nil do
	# Listar jugadores (con los que se puede jugar iniciar partida)
		players = User.all;
		content_type :json
		players.to_json
	end

	post '/players/games' do

	end

	get '/players/:id/games/:id_game' do |id, idgame|

	end

	put '/players/:id/games/:id_game' do |id, idgame|

	end

	post '/players/:id/games/:id_game/move' do |id, idgame|

	end

	get '/players/:id/games' do |id|

	end

#   not_found do	
#		erb :'page_404', :layout => false
#	end

end
