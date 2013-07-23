class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]

  def index
    @streams = Stream
    @streams = @streams.by_channel(params[:channel_id]) if params.has_key? :channel_id
    respond_with :api, @streams.all
  end

  def show
    @stream = Stream.find(params[:id])
    respond_with :api, @stream
  end

  def create
    @stream = current_user.streams.create(stream_params)
    @stream.add_tags(params[:tags]) if params.has_key? :tags
    @stream.set_channel(params[:channel]) if params.has_key? :channel
    respond_with :api, @stream
  end

  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy

    respond_with :api, @stream
  end

  def update
    @stream = Stream.find(params[:id])
    @stream.channel = Channel.find(params[:channel_id]) if params.has_key? :channel_id
    @stream.attributes = stream_params
    @stream.save

    respond_with :@stream
  end

  private

  def stream_params
    params.permit(:title, :desc, :lat, :lng, :geo_reference, :thumb, :live)
  end
end
