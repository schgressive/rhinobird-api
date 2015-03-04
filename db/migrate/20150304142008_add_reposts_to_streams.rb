class AddRepostsToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :reposts, :integer
    add_column :vjs, :reposts, :integer
  end
end
