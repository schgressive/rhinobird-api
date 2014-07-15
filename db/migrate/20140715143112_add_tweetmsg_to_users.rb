class AddTweetmsgToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_tweet, :string
  end
end
