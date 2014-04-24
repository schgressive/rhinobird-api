class Pick < ActiveRecord::Base
  # Relations
  belongs_to :stream
  belongs_to :vj

  # Validations
  validates :stream_id, :vj_id, presence: true

  extend FriendlyId
  friendly_id :slug

  before_create :setup_md5

  def setup_md5
    self.slug = SecureRandom.hex
  end

end
