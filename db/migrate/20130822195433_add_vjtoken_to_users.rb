class AddVjtokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vj_room, :string
  end
end
