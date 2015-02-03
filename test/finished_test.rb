require 'test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe 'when a game finish' do

	before do 
		@user1 = User.create do |u|
			u.username = "user1"
			u.password = "12345"
			u.id=1
		end

		@user2 = User.create do |u|
			u.username = "user2"
			u.password = "12345"
			u.id=2
		end

		@board1 = Board.create(breed_id:1, user_id:@user1.id)
		@board2 = Board.create(breed_id:1, user_id:@user2.id)

		@game = Game.create(board1_id_id:@board1.id, board2_id_id: @board2.id)
		@ship_positions = [[1, 4],[2, 3],[2, 4],[3, 4],[3, 3],[4, 3],[1, 3]]
		@ship_positions.each do |pos|
			Ship.create(x:pos[0],y:pos[1],board:@board1,sunken:false)
			Ship.create(x:pos[0],y:pos[1],board:@board2,sunken:false)
		end
		#poner todos en true, menos 1. @ship_positions.pop
		@board1.ready_for_play
		@board2.ready_for_play
		@game.play

		@ship_positions = [[1, 4],[2, 3],[2, 4],[3, 4],[3, 3],[4, 3]]
		@ship_positions.each do |pos|
			Ship.where(x:pos[0], y: pos[1]).find_each do |e|
				e.sunken = true;
				e.save 		
			end
		end

	end

	after do
		Ship.destroy_all

		@board1.destroy
		@board2.destroy
		@user1.destroy
		@user2.destroy
		@game.destroy
	end

	

	it 'must return finish when is the last move' do
		#el primer jugador puede mover. el lugar es 1,3
		login_with_user(@user1)
		put '/games/'+@game.id.to_s+'/move', params = { 'row'=> 1,'column'=> 3 } 
		follow_redirect!
		last_response.body.must_include 'You win!!'
		log_out_with_user @user1
		login_with_user @user2
		get '/games/'+@game.id.to_s 
		last_response.body.must_include 'You lose'
		log_out_with_user @user2

	end

	it 'wont shot a finished game' do
		login_with_user(@user1)
		put '/games/'+@game.id.to_s+'/move', params = { 'row'=> 1,'column'=> 3 } 
		follow_redirect!
		last_response.body.must_include 'You win!!'
		put '/games/'+@game.id.to_s+'/move', params = { 'row'=> 1,'column'=> 3 } 
		follow_redirect!
		last_response.body.must_include "You win"
		log_out_with_user @user1
		login_with_user @user2
		put '/games/'+@game.id.to_s+'/move', params = { 'row'=> 1,'column'=> 3 }
		follow_redirect!
		last_response.body.must_include "You lose"
		log_out_with_user @user2
	end

	private
	def login_with_user(user)
		post '/login', params = { username: user.username, password:user.password }
	end
	def log_out_with_user(user)
		get '/logout'
	end

end