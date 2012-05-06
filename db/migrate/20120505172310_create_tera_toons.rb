class CreateTeraToons < ActiveRecord::Migration
  def change
    create_table :tera_toons do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
		add_index :tera_toons, [:user_id]
  end
end
