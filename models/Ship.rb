class Ship < ActiveRecord::Base
	validates :sunken, presence: true
	validates :x, presence:true #=> column
	validates :y, presence:true #=> row
	belongs_to :board

	def tag_class
		if self.sunken
			"hit"
		else
			"ship"
		end
	end
end