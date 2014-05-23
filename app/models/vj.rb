class Vj < ActiveRecord::Base
  # Relations
  belongs_to :user
  belongs_to :channel
  has_many :picks
  has_many :events
  has_one :timeline, as: :resource

  # Validations
  validates :user_id, :channel_id, presence: true
  validate :unique_channel, on: :create

  # Enums
  extend Enumerize
  enumerize :status, in: {created: 0, live: 1, pending: 2, archived: 3}, scope: true, default: :created

  extend FriendlyId
  friendly_id :slug

  before_create :setup_md5

  after_create do
    Timeline.create! resource: self
  end

  def unique_channel
    vjs = Vj.where(user_id: self.user_id, channel_id: self.channel_id).with_status(:created, :live).count
    if vjs > 0
      errors.add(:channel_id, "has already been taked in created or live state")
    end
  end

  def setup_md5
    self.slug = SecureRandom.hex
  end

  # placeholder
  def vj_token
  end
end
