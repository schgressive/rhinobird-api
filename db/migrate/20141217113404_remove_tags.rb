class RemoveTags < ActiveRecord::Migration
  def change
    drop_table :tags
    drop_table :streams_tags
  end
end
