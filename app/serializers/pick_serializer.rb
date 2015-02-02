class PickSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :active, :fixed_audio
  has_one :stream, serializer: FullStreamSerializer

  def id
    object.to_param
  end
end
