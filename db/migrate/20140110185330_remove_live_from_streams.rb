class RemoveLiveFromStreams < ActiveRecord::Migration
  def change
    remove_column :streams, :live
  end
end
