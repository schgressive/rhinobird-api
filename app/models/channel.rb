class Channel < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  validates :identifier, presence: true

  before_create :setup_channel
  has_and_belongs_to_many :streams

  def setup_channel
    self.id = Digest::MD5.hexdigest(self.inspect)
  end
end
