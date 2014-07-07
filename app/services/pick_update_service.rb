class PickUpdateService
  def initialize(pick, params)
    @pick = pick
    @params = params
    @vj = @pick.vj
  end

  # Only prepares the object for update, save has to be called later
  def run
    update_pick

    @pick
  end

  private

  def update_pick
    @pick.assign_attributes(@params)
    change_audio_to_current_video if @pick.fixed_audio == false
    inactivate_other_picks
  end

  def change_audio_to_current_video
    # activate only if audio was fixed on that pick
    if @pick.fixed_audio == false && @pick.active == false &&
      @pick.active_was == false && @pick.fixed_audio_was == true
      @video_pick = @vj.picks.where(active: true).first
      @video_pick.update_attributes(fixed_audio: true) if @video_pick
    end
  end

  def inactivate_other_picks
    @vj.picks.where(active: true).where("id <> ?", @pick.id).update_all(active: false) if @pick.active
    @vj.picks.where(fixed_audio: true).where("id <> ?", @pick.id).update_all(fixed_audio: false) if @pick.fixed_audio
  end
end
