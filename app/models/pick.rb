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

  after_create :set_vj_thumbnail

  def set_vj_thumbnail
    if self.active && !self.vj.thumbnail.exists?
      self.vj.thumbnail = self.stream.thumbnail
    end
  end
end
