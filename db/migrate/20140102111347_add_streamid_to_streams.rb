class AddStreamidToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :stream_id, :integer
  end
end
