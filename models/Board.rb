class Board < ActiveRecord::Base

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
