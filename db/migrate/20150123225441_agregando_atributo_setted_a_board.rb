class AgregandoAtributoSettedABoard < ActiveRecord::Migration
  def change
  	add_column :boards, :setted, :boolean, default: false
  end
end
