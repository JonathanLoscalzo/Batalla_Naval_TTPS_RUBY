require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe " session, login and logout" do
	it 'wont log in with a user on the db' do 
		post '/login',params = {'username'=>'juan', 'password'=> '12345'}

		last_response.status.must_equal 409
		last_response.body.must_include 'El Usuario juan No existe.'
	end

	it 'log in with a user on the db' do 
		user = User.create(username: 'juan', password:'12345')
		post '/login',params = {'username'=>'juan', 'password'=> '12345'}
		User.find(user.id).destroy
		last_response.status.must_equal 200
	end

	it 'won log in if any parameter is missing' do
		post '/login',params = {'username'=>'juan'}
		last_response.status.must_equal 400
		last_response.body.must_include 'Hubo un error en los datos. Intente nuevamente'
		post '/login',params = {'password'=>'juan'}
		last_response.status.must_equal 400
		last_response.body.must_include 'Hubo un error en los datos. Intente nuevamente'
	end

	it 'load login page' do
		get '/login'
		last_response.must_be :ok?
		last_response.body.must_include 'username'
		last_response.body.must_include 'password'
	end

	it 'if im logged i could logout' do 
		user = User.create(username:"juan", password:'12345')
		post '/login',params = {'username'=>'juan', 'password'=> '12345'}
		user.destroy
		last_response.status.must_equal 200
		get '/logout'
		last_response.status.must_be_close_to 300,400 # => redireccion. 
		last_response.location.must_include '/login'
		follow_redirect!
		last_response.body.must_include 'Adiós'
	end

	it 'if im not logged in, i couldnt logout' do
		get '/logout',params = {'username'=>'juan', 'password'=> '12345'} 
		follow_redirect!
		last_response.body.must_include 'No puede cerrar sesión, si no ha iniciado'
	end

end
