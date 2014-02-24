class AddVjChannelToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vj_channel_name, :string
  end
end
