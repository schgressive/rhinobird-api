class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :photo, :bio, :backdrop, :avatar,
    :video_count, :likes, :playcount, :followed

  self.root = false

  def followed
    object.followed_by? current_user
  end

  def avatar
    object.avatar_image.present? ? object.avatar_image : nil
  end

  def backdrop
    object.background_image.present? ? object.background_image.url(:cropped) : nil
  end

  def backdrop_thumb
    object.background_image.present? ? object.background_image.url(:thumb) : nil
  end

  def playcount
    object.streams.sum(:playcount)
  end

  def video_count
    object.streams.count
  end
  # optionals
  def include_video_count?
    @options.include? :stats
  end

  def include_playcount?
    @options.include? :stats
  end

end
