class FullStreamSerializer < ActiveModel::Serializer
  attributes :id, :caption, :started_on, :type, :properties, :geometry, :owner_token, :token, :thumbs, :status, :status,
    :archived_url, :stream_id, :promoted, :recording_id, :archive, :likes, :liked, :playcount, :timeline_id,
    :reposted, :reposts

  self.root = false

  has_one :user

  def timeline_id
    object.timeline.id
  end

  def reposted
    object.reposted? current_user
  end

  def liked
    current_user ? Like.by_likeable(object).by_user(current_user).exists? : false
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
      burned: object.thumbnail.url(:burned),
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
