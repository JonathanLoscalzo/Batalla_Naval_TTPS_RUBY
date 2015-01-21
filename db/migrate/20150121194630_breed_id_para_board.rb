class BreedIdParaBoard < ActiveRecord::Migration
  def change
  	rename_column :boards, :breed_id_id, :breed_id
  end
end
