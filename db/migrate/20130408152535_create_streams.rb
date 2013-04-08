class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams, id: false do |t|
      t.string :id, primary: true
      t.string :url
      t.string :title
      t.string :desc
      t.decimal :lat, precision: 6, scale: 10
      t.decimal :lng, precision: 6, scale: 10
      t.string :geo_reference
      t.time :started_on

      t.timestamps
    end
    execute "ALTER TABLE streams ADD PRIMARY KEY (id)"
  end
end
