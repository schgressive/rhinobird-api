class UserSessionSerializer < UserSerializer
  attributes :authentication_token, :id, :name, :email, :share_facebook,
    :share_twitter, :facebook_connected, :twitter_connected,
    :custom_tweet, :enable_custom_tweet, :incomplete_fields

  def twitter_connected
    object.valid_tw_token?
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


end
