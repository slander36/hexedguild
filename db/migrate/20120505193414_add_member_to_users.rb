class AddMemberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :member, :boolean, default: false
  end
end
