class Api::PicksController < Api::BaseController
  load_resource :pick, find_by: :slug
  authorize_resource only: [:destroy, :update]

  def create
    @vj = Vj.find(params[:vj_id])
    @pick = @vj.picks.create(pick_params)
    EventTrackerService.new(@pick).run
    respond_with @pick
  end

  def show
    respond_with @pick
  end

  def index
    @vj = Vj.find(params[:vj_id])
    respond_with @vj.picks
  end

  def update
    @pick.update_attributes(pick_params)
    EventTrackerService.new(@pick).run
    respond_with @pick
  end

  def destroy
    if @pick.active || @pick.active_audio
      render json: {error: "can't remove active stream"}
    else
      @pick.destroy
      respond_with @pick
    end
  end

  private

  def pick_params
    params[:stream_id] = Stream.find(params[:stream_id]).id if params[:stream_id]
    params.permit(:active_audio, :active, :stream_id)
  end
end
