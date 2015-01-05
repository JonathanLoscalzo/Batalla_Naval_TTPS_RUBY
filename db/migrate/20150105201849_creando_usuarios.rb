class CreandoUsuarios < ActiveRecord::Migration
  def change
  	create_table :products do |t|
      t.string :username, null: false, limit: 20
      t.text :password, null: false, limit: 20
      t.timestamps null: true
    end
  end
end
