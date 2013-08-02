class CreateChannelsStreams < ActiveRecord::Migration
  def change
    create_table :channels_streams, id: false do |t|
      t.references :channel
      t.references :stream
    end
    add_index :channels_streams, [:channel_id, :stream_id]
  end
end
