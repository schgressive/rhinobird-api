class CreateStreams < ActiveRecord::Migration
  def up
    create_table :streams, id: false do |t|
      t.string :id, primary: true
      t.string :url
      t.string :title
      t.string :desc
      t.decimal :lat, scale: 6, precision: 10
      t.decimal :lng, precision: 10, scale: 6
      t.string :geo_reference
      t.datetime :started_on

      t.timestamps
    end
    execute "ALTER TABLE streams ADD PRIMARY KEY (id)"
  end
  def down
    drop_table :streams
  end
end
