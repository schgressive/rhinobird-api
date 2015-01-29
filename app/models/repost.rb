class Repost < ActiveRecord::Base
  has_one :timeline, as: :resource, dependent: :destroy
  belongs_to :user
  belongs_to :linked_timeline, class_name: "Timeline", foreign_key: :timeline_id

  after_create do
    Timeline.create! resource: self, status: :archived
  end
end
