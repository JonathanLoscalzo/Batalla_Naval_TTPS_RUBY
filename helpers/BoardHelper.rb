module Sinatra
	module BoardHelper
		#Helpers
		module Helpers
			def show_all_board(board)
				block = ->(y,x,elem) do
					"class=\""+elem.tag_class+"\"" unless elem.nil?
				end
				tag_board(board){block}
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
				tag_board(board){block}
			end

			private
			def create_mat(size)
				mat = []
				(1..size).each do
					mat << Array.new(size)
				end
				mat
			end

			def fill_mat(mat, &board)
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
				fill_mat(board, mat) # => con la anterior funcion consigo un mapa "matriz" de barcos
				mat2 = mat.map.with_index { |row, y| row.map.with_index { |column, x| block.call y, x, column }}
				str = "<table class=\"board\">"
				(1..size).each.with_index do |row, y|
					str << '<tr>'
					(1..size).each.with_index do |column, x| 
						str << '<td'
						str << column unless column.nil?
						str <<'></td>'
					end
					str << '</tr>'
				end
				str << '</table>'
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