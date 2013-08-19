class CreateStreamPools < ActiveRecord::Migration
  def change
    create_table :stream_pools do |t|
      t.references :stream
      t.references :user
      t.boolean :active

      t.timestamps
    end
    add_index :stream_pools, :stream_id
    add_index :stream_pools, :user_id
  end
end
