class Channel < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  extend FriendlyId
  friendly_id :hash_token

  before_create :setup_channel
  has_and_belongs_to_many :streams

  def setup_channel
    self.hash_token = Digest::MD5.hexdigest(self.inspect + Time.now.to_s)
  end
end
