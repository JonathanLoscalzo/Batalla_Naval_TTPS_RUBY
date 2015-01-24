module Sinatra
	module BoardHelper
		#Helpers
		module Helpers
			def show_all_board(game)
				block = ->(y,x,elem) do
					"class=\""+elem.tag_class+"\"" unless elem.nil?
				end
				board = game.get_board_from_user(actual_user_id)
				tag_board(board, &block)
			end

			def show_only_hits(board)
				block = ->(y,x,elem) do
					if elem.kind_of? Ship && elem.sunken
						"class=\""+elem.tag_class+"\""
					else
						if elem.kind_of?  Water
							"class=\""+elem.tag_class+"\""
						end
					end
				end
				tag_board(board,&block)
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

			def tag_board(board, &block)
				#block deberia ser un lambda
				size = board.breed.size
				mat = create_mat(size) # => devuelve una matriz 1 por lugar que representa x,y.
				fill_mat(mat, board) # => con la anterior funcion consigo un mapa "matriz" de barcos
				mat2 = mat.map.with_index { |row, y| row.map.with_index { |column, x| block.call y, x, column }}
				str = "<table class=\"board\">"
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
				size = board.breed.size
				str = ""
				(1..size).each.with_index do |column, x| 
					str << "<img src=\"/images/ship.png\""
					str << "id=\"ship-"+x.to_s+"\""
					str << " class=\"ship\""
					if board.get_ship_position(x)
						str << " ship-position=\""+board.get_ship_position(x).to_s+"\""
					end
					str << "/>"
				end
				str
			end

			def input_ships(game)
				board = game.get_board_from_user(actual_user_id)
				size = board.breed.size
				str = ""
				(1..size).each.with_index do |column, x| 
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