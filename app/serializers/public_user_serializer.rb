class PublicUserSerializer < ActiveModel::Serializer
  attributes  :id, :name, :username, :photo, :bio, :backdrop, :avatar
  self.root = false

  has_one :stream, key: :last_stream, serializer: SimpleStreamSerializer

  def avatar
    object.avatar_image.present? ? object.avatar_image : nil
  end

  def backdrop
    object.background_image.present? ? object.background_image.url(:cropped) : nil
  end

  def backdrop_thumb
    object.background_image.present? ? object.background_image.url(:thumb) : nil
  end

end