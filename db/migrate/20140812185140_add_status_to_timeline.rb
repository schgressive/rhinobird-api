class AddStatusToTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :status, :integer
  end
end
