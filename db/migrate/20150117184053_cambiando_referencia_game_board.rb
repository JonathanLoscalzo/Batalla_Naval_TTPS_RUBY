class CambiandoReferenciaGameBoard < ActiveRecord::Migration
	def change
		remove_column :boards, :game_id, :integer
		add_belongs_to :games, :board1_id
		add_belongs_to :games, :board2_id
	end

end
