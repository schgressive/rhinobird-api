class CreateChannelsStreams < ActiveRecord::Migration
  def up
    create_table :channels_streams, id: false do |t|
      t.string :stream_id
      t.string :channel_id
    end
    execute "ALTER TABLE channels_streams ADD PRIMARY KEY (channel_id, stream_id)"
  end

  def down
    drop_table :channels_streams
  end
end
