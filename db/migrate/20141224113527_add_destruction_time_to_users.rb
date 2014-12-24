class AddDestructionTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :destruction_time, :datetime
    add_column :users, :status, :integer, default: 0 #active
  end
end
