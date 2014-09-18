class AddTokenColumnsToUsers < ActiveRecord::Migration
  def change
    User.delete_all
    add_column :users, :token, :string
    add_column :users, :secret, :string
  end
end
