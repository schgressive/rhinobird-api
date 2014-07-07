class Api::EventsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]

  def index
    @events = Event.order("created_at ASC")
    if params[:vj_id] && !params[:vj_id].empty?
      vj_id = Vj.find(params[:vj_id]).id
      @events = @events.where(vj_id: vj_id)
    end
    respond_with @events
  end
end
