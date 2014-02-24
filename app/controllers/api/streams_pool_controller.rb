class Api::StreamsPoolController < Api::BaseController
  before_filter :init_vj_service, only: [:create, :update, :destroy]

  def index
    user = User.find(params[:user_id]) if params[:user_id]
    user ||= current_user
    streams = user.stream_pools.includes(:stream).where(streams: {status: Stream::STATUSES.index(:live)})
    streams.reject! {|stream_pool| stream_pool.stream.refresh_live_status == false} if params[:force_check]

    respond_with streams
  end

  def create
    @vj_stream = @vj_service.add(params)
    respond_with @vj_stream
  end

  def update
    @vj_stream = @vj_service.update(params)
    if @vj_stream
      respond_with @vj_stream
    else
      render json: {error: "Can't activate offline stream" }, status: 409
    end
  end

  def destroy
    json = @vj_service.remove(params[:id]) ? :nothing : {error: "can't remove active stream"}
    render json: json
  end

  private

  def init_vj_service
    @vj_service = VjService.new(current_user)
  end

  def stream_pool_params
    params.permit(:stream_id, :active, :id, :connected)
  end
end
