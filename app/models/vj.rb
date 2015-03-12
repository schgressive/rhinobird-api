class Vj < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :channel
  belongs_to :source, class_name: "Vj"
  has_many :picks
  has_many :events
  has_one :timeline, as: :resource, dependent: :destroy

  # Validations
  validates :user_id, :channel_id, presence: true
  validate :unique_channel, on: :create

  # Geocoding
  reverse_geocoded_by :lat, :lng do |vj, results|
    if geo = results.first
      vj.city = geo.city
      vj.address = geo.street_address
      vj.country = geo.country
    end
  end
  after_validation :reverse_geocode  # auto-fetch address

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 2, archived: 3, for_deletion: 4}, scope: true, default: :created

  extend FriendlyId
  friendly_id :slug

  before_create :setup_md5
  after_save :update_timeline

  after_create do
    Timeline.create! resource: self, status: self.status
  end

  def update_timeline
    tl = Timeline.where(resource_type: "Vj", resource_id: self.id).first
    if tl
      tl.status = self.status
      tl.likes = self.likes
      tl.playcount = self.playcount
      tl.lat = self.lat
      tl.lng = self.lng
      tl.save
    end
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

  # Placeholder
  def refresh_live_status
  end

  def increment_playcount!
    self.update_column :playcount, self.playcount + 1
  end

  def reposted?(user)
    return false if user.nil?
    Vj.where(user_id: user.id, source_id: self.id).exists?
  end

  def reposts
    Vj.where(source_id: self.id).count
  end


end
