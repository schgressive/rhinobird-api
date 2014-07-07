class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :vj
      t.references :stream
      t.datetime :start_time
      t.integer :duration, default: 0
      t.integer :track_type

      t.timestamps
    end
    add_index :events, [:vj_id, :stream_id]
  end
end
