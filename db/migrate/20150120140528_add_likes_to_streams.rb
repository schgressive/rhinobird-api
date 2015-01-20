class AddLikesToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :likes, :integer, default: 0
    add_column :vjs, :likes, :integer, default: 0
  end
end
