class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :hash_token, null: false

      t.timestamps
    end
    add_index :channels, :hash_token, unique: true
  end
end
