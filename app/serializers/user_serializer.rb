class UserSerializer < ActiveModel::Serializer
  attributes  :name, :email, :vj, :username, :cantidad, :vj_token, :photo, :vj_channel_name
  self.root = false

  has_many :streams, embed: :ids, embed_key: :to_param

  def cantidad
    object.stream_pools.size
  end

  def streams
    object.streams.recent.page(1)
  end

  def vj
    object.vj?
  end

  def vj_token
    object.vj_token
  end

  def include_vj_token?
    object.show_pool
  end
end
