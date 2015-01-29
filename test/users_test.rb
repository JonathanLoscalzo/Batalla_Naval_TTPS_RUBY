require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest
describe "when a user registrate" do
	it 'wont registrate if a user has the same name' do 
		user = User.create(username: 'juan', password:'12345')
		post '/players', params = {'username'=>'juan', 'password'=> '12345'}
		User.find(user.id).destroy
		last_response.status.must_equal 409
		last_response.body.must_include 'El Usuario juan ya existe.'
	end

	it 'registrate if conditions are ok' do 
		post '/players',params = {'username'=>'juan', 'password'=> '12345'}
		last_response.status.must_equal 200
		last_response.body.must_include 'Creado Correctamente'
		User.exists?(:username => "juan").must_equal true
		User.find_by(username:'juan').destroy
	end

	it 'won registrate if any parameter is missing' do
		post '/players',params = {'username'=>'juan'}
		last_response.status.must_equal 400
		last_response.body.must_include 'Datos Erronéos'
		post '/players',params = {'password'=>'juan'}
		last_response.status.must_equal 400
		last_response.body.must_include 'Datos Erronéos'
	end

end
