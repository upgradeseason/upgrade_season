class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    #Need to add to the USERS table
    add_column :users, :admin, :boolean, default: false
  end
end
