class AddAttachmentThumbnailToStreams < ActiveRecord::Migration
  def self.up
    change_table :streams do |t|
      t.attachment :thumbnail
    end
  end

  def self.down
    drop_attached_file :streams, :thumbnail
  end
end
