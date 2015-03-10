class AddTotalWatchesToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :likes, :integer
    add_column :channels, :stream_likes, :integer
  end
end
