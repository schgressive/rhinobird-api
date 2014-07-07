class CreateVjs < ActiveRecord::Migration
  def change
    create_table :vjs do |t|
      t.references :user
      t.references :channel
      t.string :archived_url
      t.integer :status

      t.timestamps
    end
    add_index :vjs, [:user_id, :channel_id]
  end
end
