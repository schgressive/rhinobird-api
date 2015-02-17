class Stream < ActiveRecord::Base
  attr_accessor :share_facebook, :share_twitter

  # Geocoding
  reverse_geocoded_by :lat, :lng do |stream, results|
    if geo = results.first
      stream.city = geo.city
      stream.address = geo.street_address
      stream.country = geo.country
    end
  end
  after_validation :reverse_geocode  # auto-fetch address

  # scopes
  scope :recent, order("created_at DESC")

  # VALIDATIONS
  validates :user_id, presence: true

  # default number of results per page
  paginates_per 12

  # CALLBACKS
  before_create :setup_stream
  after_save :update_channels
  after_save :update_timeline

  after_create do
    Timeline.create! resource: self, status: self.status
  end

  # RELATIONS
  belongs_to :user
  belongs_to :source, class_name: "Stream"
  has_and_belongs_to_many :channels
  has_one :timeline, as: :resource, dependent: :destroy

  attr_accessor :ignore_token

  has_attached_file :thumbnail, styles: {
    small: '33%',
    medium: '66%',
    large: '100%'
  },
  s3_headers: {
    'Content-Disposition' => "attachment;"
  },
#   url: "/system/:hash-:style.:extension",
#  hash_secret: "hash_secret"
  url: "/system/:slug-:style.:extension"

  extend FriendlyId
  friendly_id :hash_token

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 3, archived: 2, for_deletion: 4}, scope: true, default: :created # pending is first for backguard compatibility

  def update_timeline
    tl = Timeline.where(resource_type: "Stream", resource_id: self.id).first
    if tl
      tl.promoted = self.promoted
      tl.status = self.status
      tl.save
    end
  end

  def full_stream_url
    "#{ENV["HOST_PROTOCOL"]}://#{ENV["PUBLIC_HOST"]}/stream/#{self.to_param}"
  end

  def update_channels
    self.channels = Channel.get_channels(self.caption)
  end

  def setup_stream
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
    self.started_on = Time.now
  end

  #placeholder for licode owner token
  def owner_token
  end
  #placeholder for licode token
  def token
  end

  #placeholder to refresh live status
  def refresh_live_status
    self.status.live?
  end

  def increment_playcount!
    self.update_column :playcount, self.playcount + 1
  end

  #decodes 'data:image/jpg;base64,#{base64_image}'
  def thumb=(value)
    PaperclipHelper.process(value, 'thumb') do |img|
      self.thumbnail = img
    end
  end

  def reposted?(user)
    return false if user.nil?
    Stream.where(user_id: user.id, source_id: self.id).exists?
  end

  def reposts
    Stream.where(source_id: self.id).count
  end

  def live_viewers
    viewers = 0
    if self.status.live?
      users = NUVE.getUsers(self.to_param)
      users = JSON.parse(users)
      viewers = users.count {|v| v["role"] == "viewer"}
    end
    viewers
  rescue
    0
  end

end
