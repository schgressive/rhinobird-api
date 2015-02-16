class AddRepostedToTimeline < ActiveRecord::Migration
  def change
    add_column :timelines, :reposted, :boolean, default: false
  end
end
