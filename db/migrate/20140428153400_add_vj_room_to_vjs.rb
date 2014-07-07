class AddVjRoomToVjs < ActiveRecord::Migration
  def change
    add_column :vjs, :vj_room, :string
  end
end
