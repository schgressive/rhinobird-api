class StreamPoolSerializer < ActiveModel::Serializer
  attributes :active
  self.root = false

  has_one :stream
end
