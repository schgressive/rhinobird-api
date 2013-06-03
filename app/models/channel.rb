class Channel < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true, format: {with: /^[a-zA-Z][\w]+$/}

  extend FriendlyId
  friendly_id :hash_token

  before_create :setup_channel
  has_many :streams

  def setup_channel
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
  end
end
