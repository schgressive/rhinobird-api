class StreamPoolSerializer < ActiveModel::Serializer
  attributes :active, :token, :connected, :audio_active
  self.root = false

  has_one :stream

  def token
    object.user.vj_token
  end
end
