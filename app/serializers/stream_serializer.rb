class StreamSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :desc, :started_on, :channels, :type, :properties, :geometry, :token
  self.root = false


  #to make valid geoJSON
  def type
    "Feature"
  end

  # Use hash_token as ID
  def id
    object.to_param
  end

  def geometry
    {"coordinates" => [object.lat.to_f, object.lng.to_f], "type" => "Point"}
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
