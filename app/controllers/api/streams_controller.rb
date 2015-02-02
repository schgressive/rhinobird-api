class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index, :related]
  after_filter only: [:index] { set_pagination_headers(:streams) }

  def index
    @streams = StreamSearchService.new(params).run
    respond_with @streams.all
  end

  def show
    @stream = Stream.find(params[:id])
    @stream.refresh_live_status
    @stream.increment_playcount!
    respond_with @stream, live: true, serializer: FullStreamSerializer
  end

  def create
    @stream = StreamCreateService.new(current_user, params).run
    respond_with @stream
  end

  def destroy
    @stream = current_user.streams.find(params[:id])
    @stream.destroy

    respond_with @stream
  rescue ActiveRecord::RecordNotFound => e
    render nothing: true, status: 401
  end

  def update
    @stream = Stream.find(params[:id])
    @stream = StreamUpdateService.new(current_user, @stream, stream_params).run

    respond_with @stream
  end

  def related
    @streams = StreamSearchService.new(params).run
    respond_with @streams.all
  end

  private

  def stream_params
    params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live,
                  :stream_id, :archived_url, :share_facebook, :share_twitter,
                  :recording_id, :archive)
  end
end
