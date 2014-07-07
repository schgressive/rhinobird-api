class ChangeAudioToPicks < ActiveRecord::Migration
  def change
    rename_column :picks, :active_audio, :fixed_audio
  end
end
