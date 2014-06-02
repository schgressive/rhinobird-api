class VjUpdateService
  def initialize(vj, params)
    @params = params
    @vj = vj
  end

  def run
    @vj.update_attributes(@params)
    finish_events if @vj.status.pending?
    @vj
  end

  private

  # sets the duration of the last events
  def finish_events
    audio_event = @vj.fetch_last_event(:audio)
    audio_event.set_duration_now! unless audio_event.nil?
    video_event = @vj.fetch_last_event(:video)
    video_event.set_duration_now! unless video_event.nil?
  end
end
