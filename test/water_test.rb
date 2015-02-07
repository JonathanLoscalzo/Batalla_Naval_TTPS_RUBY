require_relative './test_helper'

describe 'a ship' do
	before do
		@water  = Water.create(x:0,y:0,board_id:1)
	end

	after do 
		Water.destroy_all
	end

	it 'receive a shot' do
		@water.receive_shot.must_equal ({:value => 'AGUA!!!!', :type => "success"})
	end

	it 'tag class is hit' do
		@water.tag_class.must_equal "miss"
	end

end