class EventSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :track_type, :duration, :start_time
  has_one :stream

  def duration
    object.to_hms
  end

  def start_time
    object.start_time.to_s(:api)
  end

end
