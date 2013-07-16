class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  self.root = false
end
