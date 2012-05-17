class AddApplyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apply, :string
  end
end
