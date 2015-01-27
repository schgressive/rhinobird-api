class CreateFollowing < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :user, null: false
      t.references :followed_user, null: false

      t.timestamps
    end
    add_index :follows, [:user_id, :followed_user_id]
  end
end
