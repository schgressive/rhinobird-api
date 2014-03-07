class AddAudioToStreamPools < ActiveRecord::Migration
  def change
    add_column :stream_pools, :audio_active, :boolean
  end
end
