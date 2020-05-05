class AddIsadminToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :isadmin, :boolean, default: false
  end
end
