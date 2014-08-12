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
    Timeline.create! resource: self
  end

  # RELATIONS
  belongs_to :user
  has_and_belongs_to_many :tags
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
  url: "/system/:hash-:style.:extension",
  hash_secret: "hash_secret"

  extend FriendlyId
  friendly_id :hash_token

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 3, archived: 2}, scope: true, default: :created # pending is first for backguard compatibility

  def update_timeline
    tl = Timeline.where(resource_type: "Stream", resource_id: self.id).first
    if tl
      tl.promoted = self.promoted
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

  #placeholder for lynckia token
  def token
  end

  #placeholder to refresh live status
  def refresh_live_status
    self.status.live?
  end

  #decodes 'data:image/jpg;base64,#{base64_image}'
  def thumb=(value)
    unless value.empty?
      content, base64 = value.split(";")
      base64 = base64.split(",").last
      content = content.split(":").last

      PaperclipAttachment.open(Base64.decode64(base64)) do |data|
        data.original_filename = "thumb.jpg"
        data.content_type = content
        self.thumbnail = data
      end
    end
  end


  #assigns a new tag to a stream
  def add_tag(tag_name)
    tag = Tag.find_or_create_by_name(tag_name.strip)
    self.tags << tag unless self.tags.include?(tag)
  end

  def remove_tag(tag_name)
    tag = Tag.find(tag_name.strip)
    self.tags.delete(tag)
  end

  #adds tags specified in a string separated by commas
  #rock, grunge
  def add_tags(tags_string)
    unless tags_string.empty?
      tags_string.split(",").each do |new_tag|
        add_tag(new_tag)
      end
    end
  end

  def increment_playcount!
    self.playcount ||= 0
    self.playcount += 1
    self.save
  end


  private
  class PaperclipAttachment < StringIO
    attr_accessor :original_filename, :content_type
  end
end
