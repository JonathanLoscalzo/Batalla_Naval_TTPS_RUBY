require_relative './test_helper'

describe 'a board' do

	before do 
		@board = Board.create(breed_id: 1, user_id:1)
	end

	after do 
		Board.destroy_all
	end

	it ' has position returns water or ship' do
		ship = Ship.create(x:1, y:1, board_id: @board.id)
		water = Water.create(x:1, y:2, board_id:@board.id)
		@board.has_position?(1,1).class.must_equal  Ship
		@board.has_position?(1,2).class.must_equal Water
		@board.has_position?(1,3).must_be_nil
		Water.destroy_all
		Ship.destroy_all
	end

	it 'returns true if all ships are sunken' do
		ship_positions = [[1, 4],[2, 3],[2, 4],[3, 4],[3, 3],[4, 3],[1, 3]]
		ship_positions.each do |pos|
			Ship.create(x:pos[0],y:pos[1],board:@board,sunken:true)
		end
		@board.all_ships_sunken?.must_equal true
		Ship.destroy_all
	end

	it 'returns false if any ship arent sunken' do
		ship_positions = [[1, 4],[2, 3],[2, 4],[3, 4],[3, 3],[4, 3],[1, 3]]
		ship_positions.each do |pos|
			Ship.create(x:pos[0],y:pos[1], board_id:@board.id,sunken:false)
		end
		@board.all_ships_sunken?.must_equal false
		Ship.destroy_all
	end

	it 'returns true if a user is the owner' do
		user = User.create(username:"juan", password:"1", id:1)
		@board.user_id = 1
		@board.is_user? user.id
		User.destroy_all
	end

	it 'returns a sunken message, or create a water and returns water message when shot' do
		ship = Ship.create(x:1, y:1, board_id: @board.id, sunken:false)
		@board.ships.first.sunken.must_equal false
		@board.receive_shot(1,1).must_equal({:value => 'Le dio a un barco!!!!', :type => "success"})
		@board.ships.first.sunken.must_equal true

		@board.receive_shot(1,2).must_equal({:value => 'AGUA!!!!', :type => "success"})
		@board = Board.find(@board.id)
		@board.water_position?(2,1).class.must_equal Water
		Water.all.first.x.must_equal 2
		Water.all.first.y.must_equal 1
		Water.all.first.board_id.must_equal @board.id

		@board.waters.first.wont_be_nil
		@board.waters.first.x.must_equal 2
		@board.waters.first.y.must_equal 1
		Ship.destroy_all
		Water.destroy_all
	end

end