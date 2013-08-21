class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :vj, :username
  self.root = false

  def id
    object.to_param
  end

  def vj
    object.vj?
  end
end
