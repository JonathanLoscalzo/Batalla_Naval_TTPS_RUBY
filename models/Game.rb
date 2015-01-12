class Game < ActiveRecord::Base
	belongs_to :user1, :class_name => "User", :foreign_key => 'user1_id' # => el que inicia el juego
	belongs_to :user2, :class_name => "User", :foreign_key => 'user2_id'
	has_one :board1, :class_name => "Board", :foreign_key => 'board1_id' # => correspondiente según usuarios.
	has_one :board2, :class_name => "Board", :foreign_key => 'board2_id'
	belongs_to :last_user_move, :class_name => "User", :foreign_key => "last_user_move_id"

	# => habrìa que ver si se puede asignar "usuario => tablero. ver relacion con :through

	belongs_to :status

	def after_create 
		self.last_user_move = self.user1 # => el primero en empezar es el user1. Tengo que ponerle ID?
	end
end

