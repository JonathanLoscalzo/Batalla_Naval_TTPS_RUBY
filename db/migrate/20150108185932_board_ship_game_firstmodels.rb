class BoardShipGameFirstmodels < ActiveRecord::Migration
  def change
  	create_table :ships do | t |
  		 t.belongs_to :board, index: true
  		 t.boolean :sunken, default: true
  		 t.timestamps null: true
  	end

  	create_table :boards do |t|
  		t.belongs_to :game, index: true
  		t.timestamps null: true
  	end 

  	create_table :games do |t|
  		t.integer :last_user_move
  		t.timestamps null: true
  	end

  end
end
