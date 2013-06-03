class Stream < ActiveRecord::Base
  validates :title, :desc, presence: true

  before_create :setup_stream
  has_and_belongs_to_many :channels

  has_attached_file :thumbnail, styles: {
    small: '48x48>',
    medium: '100x100>',
    large: '240x240>'
  }

  extend FriendlyId
  friendly_id :hash_token

  def self.by_channel(channel_id)
    Stream.joins(:channels).where("channel_id = ?", channel_id)
  end

  def setup_stream
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
    self.started_on = Time.now
  end
end
