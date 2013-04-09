class Stream < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  validates :title, :desc, presence: true

  before_create :setup_stream

  def setup_stream
    self.id = Digest::MD5.hexdigest(self.inspect)
    self.started_on = Time.now
  end
end
