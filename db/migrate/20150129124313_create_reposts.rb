class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|
      t.references :timeline
      t.references :user

      t.timestamps
    end
    add_index :reposts, :timeline_id
    add_index :reposts, :user_id
  end
end
