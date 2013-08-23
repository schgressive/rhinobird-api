class AddVjtokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vj_room, :string
    change_column :stream_pools, :active, :boolean, default: false
  end
end
