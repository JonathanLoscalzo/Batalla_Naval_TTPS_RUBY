module Sinatra
	module BoardHelper
		#Helpers
		module Helpers
			def show_all_board(game)
				block = ->(y,x,board) do
					if board.water_position?(x,y)
						"class='show-water'"
					else
						if board.sunken_position?(x,y)
							"class='show-sunken'"
						else
							if board.ship_position?(x,y)
								"class='show-ship'"
							end
						end
					end
				end
				board = game.get_board_from_user(actual_user_id)
				tag_board(board,"board",&block)
			end

			def show_opponent_board(game)
				block = ->(y,x,board) do
					if board.sunken_position?(x,y)
						"class='show-sunken'"
					else
						if board.water_position?(x,y)
							"class='show-water'"
						end
					end
				end
				board = game.get_board_opponent_user(actual_user_id)
				tag_board(board,"opponent-board",&block)
			end

			def current_user_name(game)
				game.get_board_from_user(actual_user_id).user.username
			end

			def opponent_user_name(game)
				game.get_board_opponent_user(actual_user_id).user.username
			end


			def show_opponent_board(game)
				block = ->(y,x,board) do
					if board.sunken_position?(x,y)
						"class='show-sunken'"
					else
						if board.water_position?(x,y)
							"class='show-water'"
						end
					end
				end
				board = game.get_board_opponent_user(actual_user_id)
				tag_board(board,"opponent-board",&block)
			end

			def show_game_board(board)
				block = ->(y,x,board) do
					if board.water_position?(x,y)
						"class='show-water'"
					else
						if board.sunken_position?(x,y)
							"class='show-sunken'"
						else
							if board.ship_position?(x,y)
								"class='show-ship'"
							end
						end
					end
				end
				tag_board(board,"board",&block)
			end

			private
			def create_mat(size)
				mat = []
				(1..size).each do
					mat << Array.new(size)
				end
				mat
			end

			def fill_mat(mat, board)
				#llena matriz con ships o waters
				size = board.breed.size
				(1..size).each do |row|
					(1..size).each do |column|
						if board.has_position?(row,column) # => puede tener agua o ship (hundido o no)
							mat[row-1][column-1] = board.at_position(row,column) # => agrega agua o ship
						end
					end
				end
			end


			def tag_board(board, id, &block)
				#block deberia ser un lambda
				size = board.breed.size
				mat = create_mat(size) # => devuelve una matriz 1 por lugar que representa x,y.
				fill_mat(mat, board) # => con la anterior funcion consigo un mapa "matriz" de barcos
				mat2 = mat.map.with_index { |row, y| row.map.with_index { |column, x| block.call y, x, board }}
				str = "<table class=\"board\" id=\""+id+"\">"
				(1..size).each.with_index do |row, y|
					str << '<tr>'
					(1..size).each.with_index do |column, x| 
						str << "<td id='"
						str << x.to_s
						str << "-"
						str << y.to_s
						str << "'"
						(str << mat2[y][x].to_s)unless mat2[y][x].nil?
						str <<'></td>'
					end
					str << '</tr>'
				end
				str << '</table>'
				str
			end

			def tag_ships(game)
				board = game.get_board_from_user(actual_user_id)
				count_ships = board.breed.count_ships
				str = ""
				(1..count_ships).each.with_index do |column, x| 
					str << "<img src=\"/images/ship.png\""
					str << "id=\"ship-"+x.to_s+"\""
					str << " class=\"ship\""
					str << "/>"
				end
				str
			end

			def input_ships(game)
				board = game.get_board_from_user(actual_user_id)
				count_ships = board.breed.count_ships
				str = ""
				(1..count_ships).each.with_index do |column, x| 
					str << "<input class='position-ship' id='position-ship-"
					str <<  x.to_s
					str << "' type='hidden' name='ships-position[]' value=''>"
				end
				str
			end


		end
		#end Helpers
		#App
		def self.registered(app)
	      	app.helpers BoardHelper::Helpers
	    end
	    #end App
	end
	#End sessionHelper
	register BoardHelper #diferencia entre helper y register
end