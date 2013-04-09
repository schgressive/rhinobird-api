class Stream < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  validates :title, :desc, presence: true

  before_create :setup_stream
  has_and_belongs_to_many :channels

  def setup_stream
    self.id = Digest::MD5.hexdigest(self.inspect)
    self.started_on = Time.now
  end
end
