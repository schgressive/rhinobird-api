class StreamSerializer < ActiveModel::Serializer
  attributes :id, :caption, :started_on, :type, :properties, :geometry, :thumbs, :status, :status,
    :archived_url, :promoted, :live_viewers, :likes, :playcount, :timeline_id

  self.root = false

  has_one :user, serializer: PublicUserSerializer
  has_one :source

  def timeline_id
    object.timeline.id
  end

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

end
