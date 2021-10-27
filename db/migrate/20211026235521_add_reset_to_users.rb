class AddResetToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :reset_digest, :string
    #Here we're adding reset_digest which is a string to the users table
    add_column :users, :reset_sent_at, :datetime
  end
end
