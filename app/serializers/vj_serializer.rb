class VjSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :username, :status, :channel_name, :archived_url, :token

  has_one :user

  def id
    object.to_param
  end

  def username
    object.user.username
  end

  def status
    object.status
  end

  def channel_name
    object.channel.name
  end

  def token
    object.vj_token
  end

  def thumbs
    {
      small: object.thumbnail_full_url(:small),
      medium: object.thumbnail_full_url(:medium),
      large: object.thumbnail_full_url(:large)
    }
  end

end
