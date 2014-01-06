class Stream < ActiveRecord::Base

  # Geocoding
  reverse_geocoded_by :lat, :lng, address: :geo_reference

  # VALIDATIONS
  validates :user_id, presence: true

  # CALLBACKS
  before_create :setup_stream
  after_save :update_channels

  # RELATIONS
  belongs_to :user
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :channels

  attr_accessor :ignore_token

  has_attached_file :thumbnail, styles: {
    small: '33%',
    medium: '66%',
    large: '100%'
  },
    url: "/system/:hash-:style.:extension",
    hash_secret: "hash_secret"

  extend FriendlyId
  friendly_id :hash_token

  STATUSES = [:offline, :archived, :live]


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
    self.live
  end

  #decodes 'data:image/jpg;base64,#{base64_image}'
  def thumb=(value)
    content, base64 = value.split(";")
    base64 = base64.split(",").last
    content = content.split(":").last

    PaperclipAttachment.open(Base64.decode64(base64)) do |data|
      data.original_filename = "thumb.jpg"
      data.content_type = content
      self.thumbnail = data
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

  #Returns the thumbnail full URL
  def thumbnail_full_url(size)
    url = self.thumbnail.url(size)
    unless url =~ /^http:\/\//
      url = URI.join("http://#{ENV["DEFAULT_HOST"]}", url).to_s
    end
    url
  end

  def increment_playcount!
    self.playcount ||= 0
    self.playcount += 1
    self.save
  end

  def set_status(new_status)
    self.status = STATUSES.index(new_status)
    self.save
  end

  def get_status
    STATUSES[self.status || 0].to_s
  end


  private
  class PaperclipAttachment < StringIO
    attr_accessor :original_filename, :content_type
  end
end
