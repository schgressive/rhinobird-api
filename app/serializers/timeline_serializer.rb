class TimelineSerializer < ActiveModel::Serializer
  self.root = false
  attributes :created_at, :resource_type, :id

  has_one :resource
end
