class Breed < ActiveRecord::Base
	has_many :boards
	validates :size, :count_ships, presence:true
end