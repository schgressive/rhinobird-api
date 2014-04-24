class PickSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :active, :active_audio
  has_one :stream
end
