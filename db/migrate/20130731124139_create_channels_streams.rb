class CreateChannelsStreams < ActiveRecord::Migration
  def change
    create_table :channels_streams, id: false do |t|
      t.references :channel
      t.references :stream

      t.timestamps
    end
    add_index :channels_streams, :channel_id
    add_index :channels_streams, :stream_id
  end
end
