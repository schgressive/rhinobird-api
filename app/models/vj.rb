class Vj < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :channel

  # Validations
  validates :user_id, :channel_id, presence: true
  validates :channel_id, uniqueness: {scope: :user_id}

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 2, archived: 3}, scope: true, default: :created

  extend FriendlyId
  friendly_id :slug

  before_create :setup_md5

  def setup_md5
    self.slug = SecureRandom.hex
  end

end
