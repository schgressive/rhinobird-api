class AddEnableTweetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :enable_custom_tweet, :boolean, default: false
  end
end
