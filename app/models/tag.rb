class Tag < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, format: {with: /^[a-zA-Z][\w]+$/}
  has_and_belongs_to_many :streams

  extend FriendlyId
  friendly_id :name
end
