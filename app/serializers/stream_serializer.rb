class StreamSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :desc, :started_on, :type, :properties, :geometry, :channel
  self.root = false


  #to make valid geoJSON
  def type
    "Feature"
  end

  #can't use has_one :channel, it generates stacklevel too deep
  def channel
    return {} if object.channel.nil?
    {name: object.channel.name, id: object.channel.to_param}
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

  #format this date
  def started_on
    object.started_on.to_s(:api)
  end

end
