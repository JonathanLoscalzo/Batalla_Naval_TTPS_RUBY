require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe " session and registration" do
	it 'log in with a user register' do 
		post '/login',params = {'username'=>'juan', 'password'=> '12345'}
	end
end
