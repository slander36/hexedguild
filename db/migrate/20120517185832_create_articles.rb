class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.boolean :wow
      t.boolean :tera
      t.boolean :announcement
      t.integer :user_id

      t.timestamps
    end
		add_index :articles, [:user_id, :created_at]
  end
end
