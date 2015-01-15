#SIZE = es el tamaño del tablero. Segùn lo que quiera crear el usuario
#COUNT_SHIPS = cuantos barcos tiene el tablero. en algùn lado deberìa validar esto. 
#nose si board deberia ser un mixin o un module. Deberia hacer uso de SIZE y COUNT_SHIPS similar al template_method. 
class Board < ActiveRecord::Base
	belongs_to :game #, :foreign_key => "" Tengo que ponerla?
	has_many :ships 
	belongs_to :breed
	#has_many :waters
end
