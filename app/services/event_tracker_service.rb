class EventTrackerService
  def initialize(pick)
    @pick = pick
    @event = nil
  end

  def execute
    result = {}
    result[:video] = create_event(:video) if @pick.active
    result[:audio] = create_event(:audio) if @pick.active_audio
    result
  end

  private

  def create_event(track_type)
    set_last_event_duration(track_type)
    @event = Event.create!(vj: @pick.vj, stream: @pick.stream, track_type: track_type, start_time: Time.now)
  end

  def set_last_event_duration(track_type)
    event = fetch_last_event(track_type)
    if event && event.duration <= 0
      set_event_duration(event)
    end
  end

  def fetch_last_event(track_type)
    Event.where(vj_id: @pick.vj_id).with_track_type(track_type).order("created_at DESC").first
  end

  def set_event_duration(event)
    event.duration = (Time.now - event.stream.created_at)
    event.save
  end
end
