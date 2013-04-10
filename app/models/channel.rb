class Channel < ActiveRecord::Base
  validates :identifier, presence: true

  before_create :setup_channel
  has_and_belongs_to_many :streams

  def setup_channel
    self.id = Digest::MD5.hexdigest(self.inspect + Random.rand(999999).to_s)
  end
end
