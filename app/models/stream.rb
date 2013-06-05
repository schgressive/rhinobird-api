class Stream < ActiveRecord::Base
  validates :title, presence: true

  before_create :setup_stream
  belongs_to :channel

  has_attached_file :thumbnail, styles: {
    small: '33%',
    medium: '66%',
    large: '100%'
  },
    url: "/system/:hash-:style.:extension",
    hash_secret: "hash_secret"

  extend FriendlyId
  friendly_id :hash_token

  #scopes
  scope :by_channel, -> channel_id { where("channel_id = ?", channel_id) }

  def setup_stream
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
    self.started_on = Time.now
  end

  #placeholder for lynckia token
  def token
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

  #Returns the thumbnail full URL
  def thumbnail_full_url(size)
    url = self.thumbnail.url(size)
    unless url =~ /^http:\/\//
      url = URI.join(Rails.application.config.host, url).to_s
    end
    url
  end

  private
  class PaperclipAttachment < StringIO
    attr_accessor :original_filename, :content_type
  end
end
