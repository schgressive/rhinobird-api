class AddFbIdToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :fb_id, :string
  end
end
