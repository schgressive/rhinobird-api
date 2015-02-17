class Timeline < ActiveRecord::Base

  # Relations
  belongs_to :resource, polymorphic: true
  belongs_to :user

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 2, archived: 3}, scope: true, default: :created

  validates :resource, presence: true

  before_create do
    self.user_id = resource.user_id if resource.respond_to? :user_id
    self.repost = true if resource.source
  end
end
