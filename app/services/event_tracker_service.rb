class EventTrackerService
  def initialize(pick)
    if pick.is_a?(Hash)
      @audio_pick = pick[:audio]
      @video_pick = pick[:video]
    else
      @video_pick = pick
      @audio_pick = pick
    end
    @vj = @audio_pick.try(:vj) || @video_pick.try(:vj)
    @event = nil
  end

  def run
    result = {}
    if vj_live?
      result[:video] = create_event(:video, @video_pick) if @video_pick && @video_pick.active
      result[:audio] = create_event(:audio, @audio_pick) if @audio_pick && @audio_pick.active_audio
    end
    result
  end

  private

  def vj_live?
    @vj.status.live?
  end

  def create_event(track_type, pick)
    set_last_event_duration(track_type, pick)
    @event = Event.create!(vj: pick.vj, stream: pick.stream, track_type: track_type, start_time: Time.now)
  end

  def set_last_event_duration(track_type, pick)
    event = pick.vj.fetch_last_event(track_type)
    if event && event.duration <= 0
      event.set_duration_now!
    end
  end

end
