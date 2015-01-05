class CambiarTablaUsuarios < ActiveRecord::Migration
  def change
  	rename_table :products, :users
  end
end
