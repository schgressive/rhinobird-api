class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]

  def index
    @streams = Stream
    @streams = Channel.find(params[:channel_id]).streams if params.has_key? :channel_id
    respond_with @streams.all
  end

  def show
    @stream = Stream.find(params[:id])
    respond_with @stream
  end

  def create
    @stream = current_user.streams.create(stream_params)
    @stream.add_tags(params[:tags]) if params.has_key? :tags
    respond_with @stream
  end

  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy

    respond_with @stream
  end

  def update
    @stream = Stream.find(params[:id])
    @stream.update_attributes stream_params
    @stream.save

    respond_with @stream
  end

  private

  def stream_params
    params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live)
  end
end
