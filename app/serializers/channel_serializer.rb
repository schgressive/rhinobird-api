class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :created_at, :streams, :streams_count
  self.root = false
  has_many :streams

  #format this column
  def created_at
    object.created_at.to_s(:api)
  end

  def streams_count
    object.streams.count
  end
end
