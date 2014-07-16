class AddPromotedToTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :promoted, :boolean, default: false
  end
end
