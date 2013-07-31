class SimpleChannelSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at
  self.root = false

  #format this column
  def created_at
    object.created_at.to_s(:api) if object.created_at
  end

  def id
    object.to_param
  end

end

