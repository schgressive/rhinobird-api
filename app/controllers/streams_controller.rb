class StreamsController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :update]

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
    @stream.add_tags(params[:tags]) if params.has_key? :tags
    @stream.set_channel(params[:channel]) if params.has_key? :channel
    render json: @stream, status: :created
  end

  def destroy
    @stream = Stream.find(params[:id])
    @stream.destroy
    head :no_content
  end

  def update
    @stream = Stream.find(params[:id])
    @stream.channel = Channel.find(params[:channel_id])
    @stream.save

    render json: @stream, status: :created
  end

  private

  def stream_params
    params.permit(:title, :desc, :lat, :lng, :geo_reference, :thumb)
  end
end
