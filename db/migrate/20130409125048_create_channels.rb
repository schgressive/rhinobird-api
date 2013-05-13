class CreateChannels < ActiveRecord::Migration
  def up
    create_table :channels, id: false do |t|
      t.string :id, primary: true
      t.string :name

      t.timestamps
    end
    execute "ALTER TABLE channels ADD PRIMARY KEY (id)"
  end
  def down
    drop_table :channels
  end
end
