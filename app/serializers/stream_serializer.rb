class StreamSerializer < ActiveModel::Serializer
  attributes :id, :caption, :started_on, :type, :properties, :geometry, :owner_token, :token, :thumbs, :status, :status,
    :archived_url, :stream_id, :promoted, :recording_id, :archive

  self.root = false

  has_many :tags, embed: :ids, key: :tags, embed_key: :to_param
  has_many :channels, serializer: SimpleChannelSerializer #Using serializer that doesn't include streams to avoid Stack Too Deep exception
  has_one :user

  #to make valid geoJSON
  def type
    "Feature"
  end

  # Use hash_token as ID
  def id
    object.to_param
  end

  def thumbs
    {
      small: object.thumbnail.url(:small),
      medium: object.thumbnail.url(:medium),
      large: object.thumbnail.url(:large)
    }
  end

  def geometry
    {"coordinates" => [object.lng, object.lat], "type" => "Point"}
  end

  def properties
    {
      city: object.city,
      country: object.country,
      address: object.address
    }
  end

  #format this date
  def started_on
    object.started_on.to_s(:api) if object.started_on
  end

  def attributes
    hash = super
    hash.delete(:token) if object.ignore_token
    hash
  end
end
