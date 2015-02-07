#SIZE = es el tamaño del tablero. Segùn lo que quiera crear el usuario
#COUNT_SHIPS = cuantos barcos tiene el tablero. en algùn lado deberìa validar esto. 
#nose si board deberia ser un mixin o un module. Deberia hacer uso de SIZE y COUNT_SHIPS similar al template_method. 
class Board < ActiveRecord::Base
	has_one :game #, :foreign_key => "" Tengo que ponerla?
	has_many :ships 
	belongs_to :breed
	has_many :waters
	belongs_to :user

	def add_ship(ship)
		self.ships << ship
	end


	def ship_position?(row, column)
		self.ships.to_a.detect { |i| i.x == row && i.y == column }
	end

	def sunken_position?(row, column)
		ship = self.ship_position?(row, column)
		if(ship)
			return ship.sunken
		end
		return false
	end	

	def water_position?(row, column)
		self.waters.to_a.detect { |i| i.x == row && i.y == column }
	end

	def has_position?(row, column)
		array = self.ships.to_a
		array = array + self.waters.to_a
		array.detect(nil) { |i| i.x == row && i.y == column }
	end

	def at_position(row, column)
		has_position?(row,column)
	end

	def all_ships_sunken?
		(self.ships.detect {|s| s.sunken == false } == nil)
	end

	def ready_for_play
		self.setted = true
		self.save
	end

	def is_user? (user_id)
		self.user.id == user_id
	end

	def receive_shot(column, row)
		# => es tarea del tablero, modificar sus elementos, y no del juego. 
		elem =  self.at_position(row, column)
		if elem.nil?
			elem = Water.create(x:row, y:column, board_id:self.id)
		end
		elem.receive_shot
	end

end
