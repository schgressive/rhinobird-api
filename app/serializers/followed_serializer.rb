class FollowedSerializer < UserSerializer
  has_one :stream, key: :last_stream, serializer: StreamSerializer
end
