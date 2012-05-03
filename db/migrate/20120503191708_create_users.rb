class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :character
      t.string :email
      t.boolean :tera
      t.boolean :wow

      t.timestamps
    end
  end
end
