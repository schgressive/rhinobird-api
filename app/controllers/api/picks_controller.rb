class Api::PicksController < Api::BaseController

  def create
    @vj = Vj.find(params[:vj_id])
    params[:stream_id] = Stream.find(params[:stream_id]).id if params[:stream_id]
    @pick = @vj.picks.create(pick_params)
    respond_with @pick
  end

  def update
    @vj = Pick.find(params[:id])
    if @vj.vj.user_id != current_user.id
      respond_with @vj, status: 401
    else
      @vj.update_attributes(pick_params)
      respond_with @vj
    end
  end

  def destroy
    @vj = Pick.find(params[:id])
    if @vj.vj.user_id != current_user.id
      render json: {}, status: 401
    else
      @vj.destroy
      respond_with @vj
    end
  end

  private

  def pick_params
    params.permit(:active_audio, :active, :stream_id)
  end
end
