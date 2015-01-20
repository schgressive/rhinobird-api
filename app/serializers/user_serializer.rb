class UserSerializer < ActiveModel::Serializer
  attributes  :id, :name, :email, :username, :photo, :share_facebook,
    :share_twitter, :facebook_connected, :twitter_connected,
    :custom_tweet, :enable_custom_tweet, :incomplete_fields,
    :bio, :backdrop, :avatar,
    :video_count, :applause, :playcount #stats

  self.root = false

  def twitter_connected
    object.valid_tw_token?
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

  def share_facebook
    object.valid_fb_token? && object.share_facebook
  end

  def share_twitter
    object.valid_tw_token? && object.share_twitter
  end

  def facebook_connected
    object.valid_fb_token?
  end

  # optionals
  def include_applause?
    @options.include? :stats
  end

  def include_video_count?
    @options.include? :stats
  end

  def include_playcount?
    @options.include? :stats
  end

end
