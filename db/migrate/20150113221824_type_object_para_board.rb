class TypeObjectParaBoard < ActiveRecord::Migration
  def change
  	create_table :breeds do |t|
  		t.integer :size
  		t.integer :count_ships
  		t.timestamps null:true
  	end

  	Breed.create(id:1, size:5, count_ships:7)
  	Breed.create(id:2, size:7, count_ships:15)
  	Breed.create(id:3, size:10, count_ships:20)

  	add_belongs_to :boards, :breed_id, index:true # => un tablero tiene un tipo.
  end
end
