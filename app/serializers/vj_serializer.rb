class VjSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :username, :status, :channel_name, :archived_url

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
end
