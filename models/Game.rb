class Game < ActiveRecord::Base
	belongs_to :user1, :class_name => "User", :foreign_key => 'user1_id_id' # => el que inicia el juego
	belongs_to :user2, :class_name => "User", :foreign_key => 'user2_id_id'
	belongs_to :board1, :class_name => "Board", :foreign_key => 'board1_id_id' # => correspondiente según usuarios.
	belongs_to :board2, :class_name => "Board", :foreign_key => 'board2_id_id'
	belongs_to :user_turn, :class_name => "User", :foreign_key => "last_user_move_id_id"

	# => habrìa que ver si se puede asignar "usuario => tablero. ver relacion con :through

	belongs_to :status

	def after_create 
		self.user_turn = self.user1 # => el primero en empezar es el user1. Tengo que ponerle ID?
	end

	def user_in_game?(id_user)
		(self.user2_id_id == id_user || self.user1_id_id == id_user)
	end


	def ready_for_play?
		# => si los dos tableros fueron asignados.
		!(self.board1.nil? || self.board2.nil?)
	end

	def play
		# para que empiecen a jugar. Coloco en el estado 2
		self.status_id = 2
	end

	def finish? 
		#para saber si el juego termino. 
		# =>  si uno de los tableros tiene todos los barcos hundidos termino. 
		# => cambiar el estado a finish o lo que sea.
		if self.ready_for_play? 
			if (self.board1.all_ships_sunken? || self.board2.all_ships_sunken?)
				self.status_id = 3 # => deberia guardar quien gano?
				return true
			end
		end
		return false
	end

	def who_wins?
		# => este metodo se deberia llamar a "finish?"
		if self.finish?
			if self.board1.all_ships_sunken?
				self.board1
			else
				if self.board2_all_ships_shunken?
					self.board2
				end
			end
		end
	end
end

