class CreateTimelines < ActiveRecord::Migration
  def change
    create_table :timelines do |t|
      t.integer :resource_id
      t.string :resource_type
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
