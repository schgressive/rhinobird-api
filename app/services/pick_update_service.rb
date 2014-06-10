class PickUpdateService
  def initialize(pick, params)
    @pick = pick
    @params = params
    @vj = @pick.vj
  end

  def run
    update_pick
    generate_events

    @pick
  end

  private

  def generate_events
    # if there was another pick affected
    if @video_pick
      EventTrackerService.new({audio: @video_pick, video: nil}).run
    else
      EventTrackerService.new(@pick).run
    end

  end

  def update_pick
    @pick.assign_attributes(@params)
    change_audio_to_current_video if @pick.active_audio == false
    @pick.save
    inactivate_other_picks
  end

  def change_audio_to_current_video
    # activate only if audio was fixed on that pick
    if @pick.active_audio == false && @pick.active == false &&
      @pick.active_was == false && @pick.active_audio_was == true
      @video_pick = @vj.picks.where(active: true).first
      @video_pick.update_attributes(active_audio: true) if @video_pick
    end
  end

  def inactivate_other_picks
    @vj.picks.where(active: true).where("id <> ?", @pick.id).update_all(active: false) if @pick.active
    @vj.picks.where(active_audio: true).where("id <> ?", @pick.id).update_all(active_audio: false) if @pick.active_audio
  end
end
