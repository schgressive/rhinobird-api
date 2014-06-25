class EventTrackerService
  attr_reader :video_event, :audio_event

  def initialize(pick)
    @pick = pick
    @vj = @pick.try(:vj)
    @event = nil
  end

  def run
    if vj_live?
      if create_pick_event?
        @video_event = create_event(:video, @pick)
        @audio_event = create_event(:audio, @pick) unless (is_audio_fixed? || pick_is_last_event?(:audio))
      end

      # Generate an event if deactivating fixed audio
      @audio_event = create_event(:audio, get_active_video_pick) if @pick.lost_audio_fix?
    end
    self
  end

  private

  def get_active_video_pick
    @vj.picks.where(active: true).first
  end

  # returns true if another pick has audio_fixed
  def is_audio_fixed?
    @vj.picks.where(fixed_audio: true).where("id <> ?", @pick.id).count > 0
  end

  def vj_live?
    @vj.status.live?
  end

  def create_pick_event?
    @pick.active && !pick_is_last_event?(:video)
  end

  def pick_is_last_event?(track_type)
    last_event = @vj.fetch_last_event(track_type)
    @pick.stream_id == last_event.try(:stream_id)
  end

  def create_event(track_type, pick)
    set_last_event_duration(track_type, pick)
    @event = @vj.events.create!(stream: pick.stream, track_type: track_type, start_time: Time.now)
  end

  def set_last_event_duration(track_type, pick)
    event = @vj.fetch_last_event(track_type)
    if event && event.duration <= 0
      event.set_duration_now!
    end
  end

end
