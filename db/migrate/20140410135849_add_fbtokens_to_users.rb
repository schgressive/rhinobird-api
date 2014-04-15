class AddFbtokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_token, :string
    add_column :users, :share_facebook, :boolean, default: true
  end
end
