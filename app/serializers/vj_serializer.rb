class VjSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :username, :status, :channel_name, :archived_url, :token, :thumbs, :type, :geometry, :properties,
    :likes, :liked

  has_one :user

  def likes
    Like.by_likeable(object).count
  end

  def liked
    Like.by_likeable(object).by_user(current_user).exists?
  end

  def id
    object.to_param
  end

  def username
    object.user.username
  end

  def status
    object.status
  end

  def channel_name
    object.channel.name
  end

  def token
    object.vj_token
  end

  def thumbs
    {
      small: object.thumbnail.url(:small),
      medium: object.thumbnail.url(:medium),
      large: object.thumbnail.url(:large)
    }
  end

  # GeoJSON
  def geometry
    {"coordinates" => [object.lng.to_f, object.lat.to_f], "type" => "Point"}
  end

  #to make valid geoJSON
  def type
    "Feature"
  end

  def properties
    {
      city: object.city,
      country: object.country,
      address: object.address
    }
  end

end
