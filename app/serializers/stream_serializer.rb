class StreamSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :desc, :started_on, :channels, :type, :properties, :geometry, :thumbs
  self.root = false


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
    {"coordinates" => [object.lng.to_f, object.lat.to_f], "type" => "Point"}
  end

  def properties
    {"geo_reference" => object.geo_reference}
  end


  def channels
    object.channels.map(&:to_param)
  end

  #format this date
  def started_on
    object.started_on.to_s(:api)
  end

end
