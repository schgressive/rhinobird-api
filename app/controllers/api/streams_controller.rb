class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index, :play]

  def index
    @streams = StreamSearch.new(params).run
    respond_with @streams
  end

  def show
    @stream = Stream.find(params[:id])
    @stream.refresh_live_status
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

  def play
    @stream = Stream.find_by_id(params[:id])
    @stream.increment_playcount! if @stream

    respond_with @stream, status: (@stream ? 200 : 404)
  end

  private

  def stream_params
    params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live, :stream_id)
  end
end
