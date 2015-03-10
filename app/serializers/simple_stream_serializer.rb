class SimpleStreamSerializer < ActiveModel::Serializer
  attributes :id, :caption, :started_on, :properties, :thumbs, :status,
    :archived_url, :playcount, :likes, :username

  self.root = false

  # Use hash_token as ID
  def id
    object.to_param
  end

  def username
    object.user.try(:username)
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
