class AddPromotedToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :promoted, :boolean, default: false
  end
end
