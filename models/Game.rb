class Game < ActiveRecord::Base
=begin
	has_one :user1, :class_name => "User", :foreign_key => 'user1_id'
	has_one :user2, :class_name => "User", :foreign_key => 'user2_id'
	has_one :board1, :class_name => "Board", :foreign_key => 'board1_id'
	has_one :board2, :class_name => "Board", :foreign_key => 'board2_id'
=end
end