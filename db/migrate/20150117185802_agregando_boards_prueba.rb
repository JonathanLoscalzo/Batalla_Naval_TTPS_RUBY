class AgregandoBoardsPrueba < ActiveRecord::Migration
  def change
  	b = Board.create(breed_id_id:1)
  	b2 = Board.create(breed_id_id:1)
  	g = Game.find(1)
  	g.board1_id_id =  b.id
  	g.board2_id_id =  b2.id
  	g.save # => no olvidar esto!!!!!
  end
end
