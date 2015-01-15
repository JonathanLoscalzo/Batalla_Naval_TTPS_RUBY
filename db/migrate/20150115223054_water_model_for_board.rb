class WaterModelForBoard < ActiveRecord::Migration
  def change
  	#este es para indicar que fue un disparo en ese tablero. 
  	# para mostrar los disparos fallados

  	create_table :waters do |t|
  		t.integer :x
  		t.integer :y
  		t.belongs_to :board, index:true
  		t.timestamps null:true
  	end

  	add_column :ships, :x, :integer
  	add_column :ships, :y, :integer

  end
end
