#SIZE = es el tamaño del tablero. Segùn lo que quiera crear el usuario
#COUNT_SHIPS = cuantos barcos tiene el tablero. en algùn lado deberìa validar esto. 
#nose si board deberia ser un mixin o un module. Deberia hacer uso de SIZE y COUNT_SHIPS similar al template_method. 
class Board < ActiveRecord::Base
	belongs_to :game #, :foreign_key => "" Tengo que ponerla?
	has_many :ships 
end

class SmallBoard < Board
	SIZE = 5
	COUNT_SHIPS = 7
end

class MediumBoard < Board
	SIZE = 7
	COUNT_SHIPS = 15
end

class LargeBoard < Board
	SIZE = 10
	COUNT_SHIPS = 20
end
