require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe " session and registration" do
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
end
