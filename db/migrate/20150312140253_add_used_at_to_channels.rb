class AddUsedAtToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :used_at, :datetime
    Channel.all.each {|c| c.update_column :used_at, c.updated_at }
  end
end
