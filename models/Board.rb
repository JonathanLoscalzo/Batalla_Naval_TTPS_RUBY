#SIZE = es el tamaño del tablero. Segùn lo que quiera crear el usuario
#COUNT_SHIPS = cuantos barcos tiene el tablero. en algùn lado deberìa validar esto. 
#nose si board deberia ser un mixin o un module. Deberia hacer uso de SIZE y COUNT_SHIPS similar al template_method. 
class Board < ActiveRecord::Base
	has_one :game #, :foreign_key => "" Tengo que ponerla?
	has_many :ships 
	belongs_to :breed
	has_many :waters
	belongs_to :user

	def has_position?(row, column)
		array = self.waters
		array << self.ships
		array.detect { |i| i.x == column && i.y == row }
	end

	def at_position(row, column)
		has_position?(row,column)
	end

	def all_ships_sunken?
		self.ships.detect(false) {|s| !s.sunken }
	end

	def is_user? (user_id)
		self.user.id == user_id
	end

end
