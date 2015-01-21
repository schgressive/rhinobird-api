class AddPlaycountToVjs < ActiveRecord::Migration
  def change
    add_column :vjs, :playcount, :integer, default: 0
  end
end
