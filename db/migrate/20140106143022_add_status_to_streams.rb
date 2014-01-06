class AddStatusToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :status, :integer, default: 0
  end
end
