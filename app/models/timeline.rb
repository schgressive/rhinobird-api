class Timeline < ActiveRecord::Base

  belongs_to :resource, polymorphic: true
  belongs_to :user

  validates :resource, presence: true

  before_create do
    self.user_id = resource.user_id if resource.respond_to? :user_id
  end
end
