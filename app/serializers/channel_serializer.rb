class ChannelSerializer < ActiveModel::Serializer
  attributes :id, :identifier, :created_at, :streams, :streams_count
  self.root = false
  has_many :streams

  #format this column
  def created_at
    object.created_at.try(:strftime, "%Y-%m-%dT%H:%M:%S.%3N")
  end

  def streams_count
    object.streams.count
  end
end
