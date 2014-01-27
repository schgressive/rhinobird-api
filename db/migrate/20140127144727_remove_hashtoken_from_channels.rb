class RemoveHashtokenFromChannels < ActiveRecord::Migration
  def change
    remove_column :channels, :hash_token
  end
end
