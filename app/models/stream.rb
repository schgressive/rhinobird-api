class Stream < ActiveRecord::Base
  validates :title, :desc, presence: true

  before_create :setup_stream
  belongs_to :channel

  extend FriendlyId
  friendly_id :hash_token

  def self.by_channel(channel_id)
    Stream.where("channel_id = ?", channel_id)
  end

  def setup_stream
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
    self.started_on = Time.now
  end
end
