class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :streams_tags, id: false do |t|
      t.references :tag, :stream
    end
    add_index :streams_tags, :tag_id
    add_index :streams_tags, :stream_id
  end
end
