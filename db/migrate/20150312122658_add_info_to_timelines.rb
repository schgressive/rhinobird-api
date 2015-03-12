class AddInfoToTimelines < ActiveRecord::Migration
  def change
    add_column :timelines, :likes, :integer
    add_column :timelines, :lat, :decimal, precision: 18, scale: 12
    add_column :timelines, :lng, :decimal, precision: 18, scale: 12
    add_column :timelines, :playcount, :integer
    Stream.all.each {|s| s.update_timeline}
    Vj.all.each {|v| v.update_timeline}
  end
end
