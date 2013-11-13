class AddPlaycountToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :playcount, :integer, default: 0
  end
end
