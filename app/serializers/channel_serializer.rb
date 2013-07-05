class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :streams, :streams_count
  self.root = false
  has_many :streams

  #format this column
  def created_at
    object.created_at.to_s(:api) if object.created_at
  end

  def id
    object.to_param
  end

  def streams_count
    object.streams.count
  end
end
