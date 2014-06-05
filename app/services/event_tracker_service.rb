class EventTrackerService
  def initialize(pick)
    @pick = pick
    @event = nil
  end

  def execute
    result = {}
    if vj_live?
      result[:video] = create_event(:video) if @pick.active
      result[:audio] = create_event(:audio) if @pick.active_audio
    end
    result
  end

  private

  def vj_live?
    @pick.vj.status.live?
  end

  def create_event(track_type)
    set_last_event_duration(track_type)
    @event = Event.create!(vj: @pick.vj, stream: @pick.stream, track_type: track_type, start_time: Time.now)
  end

  def set_last_event_duration(track_type)
    event = @pick.vj.fetch_last_event(track_type)
    if event && event.duration <= 0
      event.set_duration_now!
    end
  end

end
