class CreateWowToons < ActiveRecord::Migration
  def change
    create_table :wow_toons do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
		add_index :wow_toons, [:user_id]
  end
end
