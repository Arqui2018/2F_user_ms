class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :authentication_token, :string, limit: 30
    add_column :users, :nickname, :string, unique: true
    add_column :users, :wallet_id, :integer, unique: true
    add_column :users, :name, :string
    add_index :users, :authentication_token, unique: true
  end
end
