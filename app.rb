require 'bundler'

ENV['RACK_ENV'] ||= 'development'
Bundler.require :default, ENV['RACK_ENV'].to_sym

Dir['./models/**/*.rb'].each {|f| require f }

class Application < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	configure :production, :development do
	enable :logging
	end

	configure :development do
		enable :show_exceptions
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
		p params.to_s
	end

	get '/players' do

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

	not_found do
		
		erb :'page_404', :layout => false
	end

end
