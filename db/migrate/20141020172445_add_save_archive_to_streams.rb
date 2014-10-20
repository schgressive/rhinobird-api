class AddSaveArchiveToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :archive, :boolean, default: true
  end
end
