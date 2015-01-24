class Water < ActiveRecord::Base
	validates :x, presence:true #=> column
	validates :y, presence:true #=> row
	belongs_to :board

	def tag_class
		"miss"
	end

	def receive_shot
		return {:value => 'AGUA!!!!', :type => "success"}
	end
end