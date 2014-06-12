class VjUpdateService
  def initialize(vj, params)
    @params = params
    @vj = vj
  end

  def run
    @vj.update_attributes(@params)

    case @vj.status
    when "pending"
      finish_events
    when "live"
      init_events
    end

    @vj
  end

  private

  def init_events
    @vj.picks.map{|pick| EventTrackerService.new(pick).run if (pick.active || pick.fixed_audio) }
  end

  # sets the duration of the last events
  def finish_events
    audio_event = @vj.fetch_last_event(:audio)
    audio_event.set_duration_now! unless audio_event.nil?
    video_event = @vj.fetch_last_event(:video)
    video_event.set_duration_now! unless video_event.nil?
  end
end
