class CreateChannelsStreams < ActiveRecord::Migration
  def change
    create_table :channels_streams, id: false do |t|
      t.references :stream
      t.references :channel
    end
  end
end
