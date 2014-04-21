class RemoveVjfieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :vj_room
    remove_column :users, :vj_channel_name
    drop_table :stream_pools
  end
end
