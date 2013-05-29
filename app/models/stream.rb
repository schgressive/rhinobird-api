class Stream < ActiveRecord::Base
  validates :title, presence: true

  before_create :setup_stream
  has_and_belongs_to_many :channels

  extend FriendlyId
  friendly_id :hash_token

  #scopes
  scope :by_channel, -> channel_id { joins(:channels).where("channel_id = ?", channel_id) }

  def setup_stream
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
    self.started_on = Time.now
  end

  #placeholder for lynckia token
  def token
  end
end
