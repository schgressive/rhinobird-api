class AddSplitgeoToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :city, :string
    add_column :streams, :address, :string
    add_column :streams, :country, :string
    remove_column :streams, :geo_reference
  end
end
