class AddRecordingidToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :recording_id, :integer
  end
end
