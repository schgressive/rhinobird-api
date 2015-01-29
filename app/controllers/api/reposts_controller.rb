class Api::RepostsController < Api::BaseController

  def create
    timeline = Timeline.find(params[:timeline_id])
    @repost = current_user.reposts.create(timeline_id: timeline.id)
    respond_with @repost
  end

end
