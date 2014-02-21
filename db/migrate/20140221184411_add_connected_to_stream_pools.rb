class AddConnectedToStreamPools < ActiveRecord::Migration
  def change
    add_column :stream_pools, :connected, :boolean, default: false
  end
end
