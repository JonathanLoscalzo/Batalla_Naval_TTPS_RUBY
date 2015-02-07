require_relative './test_helper'

describe 'a ship' do
	before do
		@ship  = Ship.create(x:0,y:0,board:@board1,sunken:false)
	end

	after do 
		Ship.destroy_all
	end

	it 'receive a shot if not sunken' do
		@ship.sunken.must_equal false
		@ship.receive_shot.must_equal ({:value => 'Le dio a un barco!!!!', :type => "success"})
		@ship.sunken.must_equal true
	end

	it 'receive a shot if not sunken' do
		@ship.receive_shot
		@ship.receive_shot.must_be_nil
	end

	it 'tag class is hit' do
		@ship.tag_class.must_equal ""
		@ship.receive_shot
		@ship.tag_class.must_equal "hit"
	end

end