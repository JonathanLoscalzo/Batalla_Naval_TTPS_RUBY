require 'bundler'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir['./models/**/*.rb'].each {|f| require f } # => requiero todos los archivos en models/*.rb

enable :sessions

class Application < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	configure :production, :development do
		enable :logging
	end

	configure :development do
		enable :show_exceptions
		use BetterErrors::Middleware
 		BetterErrors.application_root = __dir__
	end

	set :database, YAML.load_file('config/database.yml')[ENV['RACK_ENV']]

	set :method_override, true

	get '/login' do
		erb 'login/login'.to_sym
	end

	post '/login' do
		p params.to_s
	end

	post '/players' do
	#Crear un Jugador. De datos entran username y password.
		p params.to_s
	end

	get '/players' do
	# Listar jugadores (con los que se puede jugar) 
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
