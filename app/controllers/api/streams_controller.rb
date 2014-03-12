class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index, :play, :archived, :related]
  after_filter only: [:index] { set_pagination_headers(:streams) }

  def index
    @streams = StreamSearch.new(params).run
    respond_with @streams.all
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
    stream_update = StreamUpdateService.new(@stream, stream_params)
    stream_update.save

    respond_with @stream
  end

  def play
    @stream = Stream.find_by_id(params[:id])
    @stream.increment_playcount! if @stream

    respond_with @stream, status: (@stream ? 200 : 404)
  end

  def related
    @streams = StreamSearch.new(params).run
    respond_with @streams.all
  end

  private

  def stream_params
    params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live, :stream_id, :archived_url)
  end
end
