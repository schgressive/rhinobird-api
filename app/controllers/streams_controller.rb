class StreamsController < ApplicationController

  def index
    @streams = Stream
    @streams = @streams.by_channel(params[:channel_id]) if params.has_key? :channel_id
    render json: @streams.all
  end

  def show
    @stream = Stream.find(params[:id])
    render json: @stream
  end

  def create
    @stream = Stream.create(stream_params)
    render json: @stream, status: :created
  end

  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy
    head :no_content
  end

  private

  def stream_params
    params.permit(:title, :desc, :lat, :lng, :geo_reference, :thumb)
  end
end
