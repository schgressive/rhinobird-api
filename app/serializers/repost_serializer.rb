class RepostSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :created_at
  has_one :user, serializer: PublicUserSerializer
  has_one :linked_timeline, key: :timeline
end
