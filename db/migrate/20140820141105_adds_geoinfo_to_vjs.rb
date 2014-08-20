class AddsGeoinfoToVjs < ActiveRecord::Migration
  def change
    add_column :vjs, :lat, :decimal, precision: 18, scale: 12
    add_column :vjs, :lng, :decimal, precision: 18, scale: 12
    add_column :vjs, :city, :string
    add_column :vjs, :address, :string
    add_column :vjs, :country, :string
  end
end
