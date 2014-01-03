class UserSerializer < ActiveModel::Serializer
  attributes  :name, :email, :vj, :username, :cantidad, :vj_token, :photo
  self.root = false

  def cantidad
    object.stream_pools.size
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
