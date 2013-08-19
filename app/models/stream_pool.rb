class StreamPool < ActiveRecord::Base
  # Relations
  belongs_to :stream
  belongs_to :user

  # Validations
  validates :user_id, :stream_id, presence: true
end
