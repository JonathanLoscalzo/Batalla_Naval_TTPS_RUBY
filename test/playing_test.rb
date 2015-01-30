require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe "Playing a game initialize" do
	describe "playing a game" do
		before do
			@user1 = User.create(username:"juan", password:'12345')
			@user2 = User.create(username:"pepe", password:'12345')
		end
		after do
			@user1.destroy
			@user2.destroy
			Game.last.board1.destroy
			Game.last.board2.destroy
			Game.last.destroy
			Ship.last(14) do |elem|
				elem.destroy
			end
		end
		def self.test_order
 			:alpha
		end
		it 'create game' do 
			post '/login',params = {'username'=>'juan', 'password'=> '12345'}
			post '/game/create',params = {'user_id'=>@user2.id, "select-size" => Breed.where(["size == :size", { size: "5" }]).first.id}
			last_response.status.must_equal 303
		end
		it 'loading ships in the new game' do
			post '/login',params = {'username'=>@user1.username, 'password'=> '12345'}
			post '/game/create',params = {'user_id'=>@user2.id, "select-size" => Breed.where(["size == :size", { size: "5" }]).first.id}
			@game = Game.last
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["0-1","1-2","2-2","3-2","1-3","4-4","1-2"]}
			post '/logout'
			post '/login',params = {'username'=>@user2.username, 'password'=> '12345'}
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["1-1","1-2","3-2","4-1","0-3","2-2","0-0"]}
			@game.board1.ships.length.must_equal 7
			@game.board2.ships.length.must_equal 7
			@game.board2.at_position(1,1).x.must_equal 1
			@game.board2.at_position(4,1).x.must_equal 4
			last_response.status.must_equal 302
		end
		it 'if I send less ships than the giving size' do
			post '/login',params = {'username'=>@user1.username, 'password'=> '12345'}
			post '/game/create',params = {'user_id'=>@user2.id, "select-size" => Breed.where(["size == :size", { size: "7" }]).first.id}
			@game = Game.last
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["0-1","1-2","2-2","3-2","1-3","4-4","1-2"]}
			@game.board2.ships.length.must_equal 0
		end

		it 'If I sunk a ship' do
			post '/login',params = {'username'=>@user1.username, 'password'=> '12345'}
			post '/game/create',params = {'user_id'=>@user2.id, "select-size" => Breed.where(["size == :size", { size: "5" }]).first.id}
			@game = Game.last
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["0-1","1-2","2-2","3-2","1-3","4-4","1-2"]}
			post '/logout'
			post '/login',params = {'username'=>@user2.username, 'password'=> '12345'}
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["1-1","1-2","3-2","4-1","0-3","2-2","0-0"]}
			post '/logout'
			post '/login',params = {'username'=>@user1.username, 'password'=> '12345'}
			put '/games/'+@game.id.to_s+'/move',params = {'row'=> 1,'column'=> 2} 
			@game.board2.at_position(1,2).sunken.must_equal true
		end

		it 'Is my turn?' do
			post '/login',params = {'username'=>@user1.username, 'password'=> '12345'}
			post '/game/create',params = {'user_id'=>@user2.id, "select-size" => Breed.where(["size == :size", { size: "5" }]).first.id}
			@game = Game.last
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["0-1","1-2","2-2","3-2","1-3","4-4","1-2"]}
			post '/logout'
			post '/login',params = {'username'=>@user2.username, 'password'=> '12345'}
			post '/games/'+ @game.id.to_s, params = {'ships-position'=>["1-1","1-2","3-2","4-1","0-3","2-2","0-0"]}
			@game.user_turn.id.must_equal @user1.id
		end

	end
end
