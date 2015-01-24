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

	def receive_shot
		# => recibe un disparo. Si ya recibiò un disparo pierde el turno!
		unless self.sunken
			self.sunken = true
			self.save
			return {:value => 'Le dio a un barco!!!!', :type => "success"}
		end
	end
end