require_relative './test_helper'
# => https://github.com/brandonweiss/rack-minitest

describe 'a Game' do
	describe 'initial game without ships on boards' do
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
		end

		after do 
			Ship.destroy_all
			@board1.destroy
			@board2.destroy
			@user1.destroy
			@user2.destroy
			@game.destroy
		end

		it 'if a user is in game' do
			@game.user_is_playing?(@user1.id).must_equal true
			@game.user_is_playing?(@user2.id).must_equal true
			user3 = User.create do |u|
				u.username = "user1"
				u.password = "12345"
				u.id=3
			end
			@game.user_is_playing?(user3.id).wont_equal true
			user3.destroy
		end

		it ' ready_for_play? must return false ' do
			@game.ready_for_play?.must_equal false
		end

		it 'ready for play for a user that dont send the board, returns false' do
			@game.ready_for_play(@user1.id).must_equal false
			@game.ready_for_play(@user2.id).must_equal false
		end


		it 'if get board from oponent returns other board' do
			@game.get_board_opponent_user(@user1.id).must_equal @board2
			@game.get_board_opponent_user(@user2.id).must_equal @board1
		end

		it 'if get board from user returns his board' do
			@game.get_board_from_user(@user1.id).must_equal @board1
			@game.get_board_from_user(@user2.id).must_equal @board2
		end
	end
	describe ' when a game is playing' do
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
			@game.board1.ready_for_play
			@game.board2.ready_for_play
			@game.play

			
		end

		after do 
			Ship.destroy_all
			Water.destroy_all
			@board1.destroy
			@board2.destroy
			@user1.destroy
			@user2.destroy
			@game.destroy
		end

		it 'ready for play returns true' do
			@game.ready_for_play?.must_equal true
			@game.play.must_equal true
		end
		it 'ready for play for a user that dont send the board, returns false' do
			@game.ready_for_play(@user1.id).must_equal true
			@game.ready_for_play(@user2.id).must_equal true
		end

		it ' when a shot is on a ship, this ship sunk ' do
			Ship.find_by(x:1,y:4,board_id: @game.board2.id).sunken.must_equal false
			@game.shot_to(column:4,row:1,user_id:@user1.id).must_equal({:value => 'Le dio a un barco!!!!', :type => "success"})
			Ship.find_by(x:1,y:4,board_id: @game.board2.id).sunken.must_equal true
		end

		it ' when a shot isnt on a ship, creates a water' do
			Water.find_by(x:2,y:5,board_id: @board2.id).must_be_nil
			@game.shot_to(row:2,column:5,user_id: @user1.id).must_equal({:value => 'AGUA!!!!', :type => "success"})
			Water.find_by(x:2,y:5,board_id: @board2.id).wont_be_nil
		end

	end
	
	describe 'a finish game and when finish' do
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
				Ship.create(x:pos[0],y:pos[1],board:@board1,sunken:true)
				Ship.create(x:pos[0],y:pos[1],board:@board2,sunken:false)
			end
			#poner todos en true, menos 1. @ship_positions.pop
			@game.board1.ready_for_play
			@game.board2.ready_for_play
			@game.play
			@game.finish?
		end

		after do 
			Ship.destroy_all
			@board1.destroy
			@board2.destroy
			@user1.destroy
			@user2.destroy
			@game.destroy
		end

		it 'when a game has a board with all ships sunken return finish?' do
			@game.finish?.must_equal true
		end

		it 'first user wins, returns who_wins' do
			@game.who_wins?.must_equal @user2
		end

		it 'cant shot in this state' do
			@game.shot_to(row:1, column:4, user_id:@user1.id).must_equal({ :value => "No es tu turno!", :type => "danger" })
		end

	end
end