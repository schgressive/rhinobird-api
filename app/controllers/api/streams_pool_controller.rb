class Api::StreamsPoolController < Api::BaseController

  def index
    user = User.find(params[:user_id]) if params[:user_id]
    user ||= current_user
    streams = user.stream_pools.includes(:stream).where(streams: {status: Stream::STATUSES.index(:live)})
    streams.reject! {|stream_pool| stream_pool.stream.refresh_live_status == false} if params[:force_check]

    respond_with streams
  end

  def create
    @stream_pool = StreamPool.add_to_pool(current_user, params[:stream_id], stream_pool_params)
    respond_with @stream_pool
  end

  def update
    @stream_pool = StreamPool.get_by_stream_hash(current_user, params[:id])
    @stream_pool.update_attributes(connected: params[:connected]) if params[:connected]
    if @stream_pool.set_active(params[:active])
      respond_with @stream_pool
    else
      render json: {error: "Can't activate offline stream" }, status: 409
    end
  end

  def destroy
    @stream_pool = StreamPool.get_by_stream_hash(current_user, params[:id])
    json = @stream_pool.remove_from_pool ? :nothing : {error: "can't remove active stream"}
    render json: json
  end

  private

  def stream_pool_params
    params.permit(:stream_id, :active, :id, :connected)
  end
end
