class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.references :stream
      t.references :vj
      t.string :slug
      t.boolean :active, default: false
      t.boolean :active_audio, default: false

      t.timestamps
    end
    add_index :picks, [:stream_id, :vj_id]
    add_index :picks, :slug, unique: true
  end
end
