class MudarUserToBoard < ActiveRecord::Migration
  def change
  	remove_column :games, :user1_id_id
  	remove_column :games, :user2_id_id

  	add_belongs_to :boards, :user

  end
end
