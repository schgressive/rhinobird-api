class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :vj
  self.root = false

  def vj
    object.vj?
  end
end
