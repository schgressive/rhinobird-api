class StreamSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :desc, :lat, :lng, :geo_reference, :started_on, :channels
  self.root = false

  def channels
    object.channels.map(&:id)
  end

  #convert BigDecimal -> Float
  def lat
    object.lat.to_f
  end

  def lng
    object.lng.to_f
  end

  #format this column
  def started_on
    object.started_on.to_s(:api)
  end

end
