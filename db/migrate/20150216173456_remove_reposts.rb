class RemoveReposts < ActiveRecord::Migration
  def change
    add_column :streams, :source_id, :integer, index: true
    add_column :vjs, :source_id, :integer, index: true
    drop_table :reposts
  end

end
