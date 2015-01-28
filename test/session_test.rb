require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe " session and registration" do
	it 'log in with a user register' do 
		post '/login',params = {'username'=>'juan', 'password'=> '12345'}

		last_response.wont_be :ok?
		last_response.body.must_include 'El Usuario juan No existe.'
	end

	it 'load login page' do
		get '/login'
		last_response.must_be :ok?
	end
end
