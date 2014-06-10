class Vj < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :channel
  has_many :picks
  has_many :events
  has_one :timeline, as: :resource

  # Validations
  validates :user_id, :channel_id, presence: true
  validate :unique_channel, on: :create

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 2, archived: 3}, scope: true, default: :created

  extend FriendlyId
  friendly_id :slug

  before_create :setup_md5

  after_create do
    Timeline.create! resource: self
  end

  has_attached_file :thumbnail, styles: {
    small: '33%',
    medium: '66%',
    large: '100%'
  },
  s3_headers: {
    'Content-Disposition' => "attachment;"
  },
  url: "/system/:hash-:style.:extension",
  hash_secret: "hash_secret"


  def unique_channel
    vjs = Vj.where(user_id: self.user_id, channel_id: self.channel_id).with_status(:created, :live).count
    if vjs > 0
      errors.add(:channel_id, "has already been taked in created or live state")
    end
  end

  def fetch_last_event(track_type)
    Event.where(vj_id: self.id).with_track_type(track_type).order("created_at DESC").first
  end

  def setup_md5
    self.slug = SecureRandom.hex
  end

  # placeholder
  def vj_token
  end

  #Returns the thumbnail full URL
  def thumbnail_full_url(size)
    url = self.thumbnail.url(size)
    unless url =~ /^#{ENV["HOST_PROTOCOL"]}:\/\//
      url = URI.join("#{ENV["HOST_PROTOCOL"]}://#{ENV["DEFAULT_HOST"]}", url).to_s
    end
    url
  end

end
