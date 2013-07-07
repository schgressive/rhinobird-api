class Stream < ActiveRecord::Base
  before_create :setup_stream

  belongs_to :channel
  has_and_belongs_to_many :tags

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

  #sets a channel by name
  def set_channel(name)
    self.channel = Channel.find_or_create_by_name(name.strip)
    self.save
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
