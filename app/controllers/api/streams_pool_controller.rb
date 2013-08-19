class Api::StreamsPoolController < Api::BaseController

  def index
    @streams = current_user.stream_pools

    respond_with @streams.all
  end

  def create
    @stream_pool = current_user.stream_pools.create(stream_pool_params)
    respond_with @stream_pool
  end

  private

  def stream_pool_params
    params.permit(:stream_id, :active)
  end
end
