class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :vj, :username, :cantidad, :vj_token
  self.root = false

  has_many :stream_pools

  def cantidad
    object.stream_pools.size
  end

  def id
    object.to_param
  end

  def vj
    object.vj?
  end

  def vj_token
    object.vj_token
  end
end
