class AddMembersOnlyToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :members_only, :boolean
  end
end
