class AddLikesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :likes, :integer, default: 0
  end
end
