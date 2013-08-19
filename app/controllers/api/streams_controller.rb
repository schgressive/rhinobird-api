class Api::StreamsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]

  def index
    @streams = Stream

    # filters
    @streams = Channel.find(params[:channel_id]).streams if params.has_key? :channel_id
    @streams = @streams.where(live: true) if params.has_key? :live

    @streams = @streams.order("created_at DESC")

    @streams = @streams.offset(params[:offset]) if params.has_key? :offset
    @streams = @streams.limit(params[:limit]) if params.has_key? :limit

    @streams.reject! { |stream| stream.refresh_live_status == false } if params.has_key? :force_check

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

  private

  def stream_params
    params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live)
  end
end
