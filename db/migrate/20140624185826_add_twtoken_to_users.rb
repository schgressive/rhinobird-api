class AddTwtokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tw_token, :string
    add_column :users, :tw_secret, :string
    add_column :users, :share_twitter, :boolean
  end
end
