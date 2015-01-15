class Water < ActiveRecord::Base
	validates :x, presence:true
	validates :y, presence:true
	belongs_to :board
end