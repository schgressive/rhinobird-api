class ChannelSerializer < ActiveModel::Serializer
  attributes :name, :created_at, :streams_count, :total_watches, :most_liked_streams, :stream_likes, :used_at
  self.root = false

  has_many :most_liked_streams

  #format this column
  def created_at
    object.created_at.to_s(:api) if object.created_at
  end

  def streams_count
    object.streams.with_status(:live, :archived).count
  end

  def total_watches
    object.streams.with_status(:live, :archived).sum(:playcount)
  end
end
