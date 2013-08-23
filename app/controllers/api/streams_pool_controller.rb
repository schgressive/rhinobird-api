class Api::StreamsPoolController < Api::BaseController

  def index
    @streams = current_user.stream_pools

    respond_with @streams.all
  end

  def create
    stream = Stream.find(params[:stream_id])
    params[:stream_id] = stream.id
    @stream_pool = current_user.stream_pools.create(stream_pool_params)
    respond_with @stream_pool
  end

  def update
    @stream_pool = StreamPool.get_by_stream_hash(current_user, params[:stream_id])
    if @stream_pool.set_active(params[:active])
      respond_with @stream_pool
    else
      render json: {error: "Can't activate offline stream" }, status: 409
    end
  end

  def destroy
    @stream_pool = StreamPool.get_by_stream_hash(current_user, params[:stream_id])
    json = @stream_pool.remove_from_pool ? :nothing : {error: "can't remove active stream"}
    render json: json
  end

  private

  def stream_pool_params
    params.permit(:stream_id, :active)
  end
end
