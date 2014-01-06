class StreamSerializer < ActiveModel::Serializer
  attributes :id, :caption, :started_on, :type, :properties, :geometry,  :token, :thumbs, :live, :status
  self.root = false

  has_many :tags, embed: :ids, key: :tags, embed_key: :to_param
  has_many :channels, serializer: SimpleChannelSerializer #Using serializer that doesn't include streams to avoid Stack Too Deep exception
  has_one :user

  #to make valid geoJSON
  def type
    "Feature"
  end

  def status
    object.get_status
  end

  # Use hash_token as ID
  def id
    object.to_param
  end

  def thumbs
    {
      small: object.thumbnail_full_url(:small),
      medium: object.thumbnail_full_url(:medium),
      large: object.thumbnail_full_url(:large)
    }
  end

  def geometry
    {"coordinates" => [object.lng.to_f, object.lat.to_f], "type" => "Point"}
  end

  def properties
    {"geo_reference" => object.geo_reference}
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
