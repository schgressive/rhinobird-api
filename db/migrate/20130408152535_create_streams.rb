class CreateStreams < ActiveRecord::Migration
  def up
    create_table :streams, id: false do |t|
      t.string :id, primary: true
      t.string :url
      t.string :title
      t.string :desc
      t.decimal :lat, precision: 18, scale: 12
      t.decimal :lng, precision: 18, scale: 12
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
