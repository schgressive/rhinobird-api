class StreamSerializer < ActiveModel::Serializer
  attributes :id, :id, :url, :title, :desc, :lat, :lng, :geo_reference, :started_on
end
