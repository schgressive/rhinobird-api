class Event < ActiveRecord::Base
  # Relations
  belongs_to :vj
  belongs_to :stream

  # Validations
  validates :vj_id, :stream_id, :start_time, presence: true

  # Enums
  extend Enumerize
  enumerize :track_type, in: {video: 0, audio: 1}, scope: true, default: :video

  # returns the duration in HH:mm:ss
  def to_hms
    Time.at(self.duration).gmtime.strftime('%R:%S')
  end

  def set_duration_now!
    self.duration = (Time.now - self.start_time)
    self.save
  end

end
