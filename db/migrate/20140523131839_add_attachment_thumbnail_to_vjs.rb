class AddAttachmentThumbnailToVjs < ActiveRecord::Migration
  def self.up
    change_table :vjs do |t|
      t.attachment :thumbnail
    end
  end

  def self.down
    drop_attached_file :vjs, :thumbnail
  end
end
