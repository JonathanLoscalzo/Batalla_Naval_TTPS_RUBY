class EstadosJuego < ActiveRecord::Migration
  def change
  	create_table :statuses do |t|
  		t.text :description
  		t.timestamps null:true
  	end

  	Status.create(id:1, description: "Iniciado.")
  	Status.create(id:2, description: "Esperando tableros.")
  	Status.create(id:3, description: "Jugando.")
  	Status.create(id:4, description: "Terminado.")

  	add_belongs_to :games, :status, index: true, default:1 # => agrega status_id en game. Real? nose
  	add_belongs_to :games, :user1_id, index:true
  	add_belongs_to :games, :user2_id, index:true
  	remove_column :games, :last_user_move
  	add_belongs_to :games, :last_user_move_id, index:true

  end
end
