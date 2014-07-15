class UserSerializer < ActiveModel::Serializer
  attributes  :name, :email, :username, :photo, :share_facebook, :share_twitter, :facebook_connected, :twitter_connected,
    :custom_tweet
  self.root = false

  has_many :streams, embed: :ids, embed_key: :to_param

  def streams
    object.streams.recent.page(1)
  end

  def twitter_connected
    object.valid_tw_token?
  end

  def facebook_connected
    object.valid_fb_token?
  end

end
