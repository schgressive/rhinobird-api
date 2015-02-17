class AddRepostedToTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :repost, :boolean, default: false
  end
end
