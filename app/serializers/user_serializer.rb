class UserSerializer < ActiveModel::Serializer
  attributes  :name, :email, :username, :photo, :share_facebook
  self.root = false

  has_many :streams, embed: :ids, embed_key: :to_param

  def streams
    object.streams.recent.page(1)
  end

end
