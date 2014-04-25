class Api::PicksController < Api::BaseController
  load_resource :pick, find_by: :slug
  authorize_resource only: [:destroy, :update]

  def create
    @vj = Vj.find(params[:vj_id])
    params[:stream_id] = Stream.find(params[:stream_id]).id if params[:stream_id]
    @pick = @vj.picks.create(pick_params)
    respond_with @pick
  end

  def index
    @vj = Vj.find(params[:vj_id])
    respond_with @vj.picks
  end

  def update
    @pick.update_attributes(pick_params)
    respond_with @pick
  end

  def destroy
    @pick.destroy
    respond_with @pick
  end

  private

  def pick_params
    params.permit(:active_audio, :active, :stream_id)
  end
end
