class ChannelSerializer < ActiveModel::Serializer
  attributes :name, :created_at, :streams_count
  self.root = false

  #format this column
  def created_at
    object.created_at.to_s(:api) if object.created_at
  end

  def streams_count
    object.streams.count
  end
end
