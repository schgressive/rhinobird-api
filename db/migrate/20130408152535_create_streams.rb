class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :url
      t.string :title
      t.string :desc
      t.string :hash_token, null: false, size: 1000
      t.decimal :lat, precision: 18, scale: 12
      t.decimal :lng, precision: 18, scale: 12
      t.string :geo_reference
      t.references :channel
      t.datetime :started_on

      t.timestamps
    end
    add_index :streams, :hash_token, unique: true
    add_index :streams, :channel_id
  end
end
