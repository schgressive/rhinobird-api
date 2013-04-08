class StreamsController < ApplicationController
  def index
    @streams = Stream.all
    render json: @streams
  end

  def show
    @stream = Stream.find(params[:id])
    render json: @stream
  end

  def create
    @stream = Stream.create(stream_params)
    render json: @stream, status: 201
  end

  private

  def stream_params
    params.permit(:title, :desc, :lat, :lng, :geo_reference)
  end
end
