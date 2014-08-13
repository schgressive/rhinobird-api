class ChangeRecordingidToStreams < ActiveRecord::Migration
  def change
    remove_column :streams, :recording_id
    add_column :streams, :recording_id, :decimal, precision: 22
  end
end

