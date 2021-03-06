class Game < ActiveRecord::Base
	belongs_to :board1, :class_name => "Board", :foreign_key => 'board1_id_id' # => correspondiente según usuarios.
	belongs_to :board2, :class_name => "Board", :foreign_key => 'board2_id_id'
	belongs_to :user_turn, :class_name => "User", :foreign_key => "last_user_move_id_id"
	before_create :set_user_turn

	# => habrìa que ver si se puede asignar "usuario => tablero. ver relacion con :through

	belongs_to :status

	def set_user_turn
		self.last_user_move_id_id = self.board1.user.id # => el primero en empezar es el user1. Tengo que ponerle ID? falta save?
	end

	def user_in_game?(id_user)
		(self.board2.user.id == id_user || self.board1.user.id == id_user)
	end

	def get_board_from_user(user_id)
		if(user_id == self.board1.user.id)
			return self.board1
		end
		if(user_id == self.board2.user.id)
			return self.board2
		end
		return false
	end

	def get_board_opponent_user(user_id)
		self.get_board_from_other_user(user_id)
	end

	def get_board_from_other_user(user_id)
		if(user_id == self.board1.user.id)
			return self.board2
		else
			if(user_id == self.board2.user.id)
				return self.board1
			end
		end
	end

	def ready_for_play?
		# => si los dos tableros fueron asignados.
		(self.board1.setted && self.board2.setted)
	end

	def ready_for_play(user_id)
		self.get_board_from_user(user_id).setted
	end

	def user_is_playing?(user_id)
		(self.board1.user.id == user_id || self.board2.user.id == user_id)
	end

	def user_can_play?(user_id)
		# => si los dos tableros fueron asignados.
		return (self.ready_for_play? && self.user_turn.id == user_id && self.status.id==2)
	end

	def play
		# para que empiecen a jugar. Coloco en el estado 2. validar
		if (self.ready_for_play?)
			self.status = Status.find(2)
			self.save
			return true
		else
			return false
		end
	end

	def finish? 
		#para saber si el juego termino. 
		# =>  si uno de los tableros tiene todos los barcos hundidos termino. 
		# => cambiar el estado a finish o lo que sea.
		if self.status.id == 3
			return true
		end
		if self.ready_for_play? 
			if (self.board1.all_ships_sunken? || self.board2.all_ships_sunken?)
				self.status = Status.find(3) # => deberia guardar quien gano?
				self.save
				return true
			end
		end
		return false
	end

	def who_wins?
		# => este metodo se deberia llamar a "finish?"
		if self.finish?
			if self.board1.all_ships_sunken?
				self.board2.user
			else
				if self.board2.all_ships_sunken?
					self.board1.user
				end
			end
		end
	end

	def change_last_user(next_user_id)
		# => este metodo habrìa que cambiarlo para que solo elija al otro usuario.
		self.last_user_move_id_id = next_user_id
		self.save
	end

	def shot_to(column:, row:, user_id:)
		if self.user_can_play? user_id
			board = get_board_from_other_user(user_id) # => esto si saco el sessionHelper no anda...
			message = board.receive_shot(column,row) # => es tarea del tablero modificar sus celdas.
			self.change_last_user board.user.id
		else
			message = { :value => "No es tu turno!", :type => "danger" }
		end
		message 
	end

end