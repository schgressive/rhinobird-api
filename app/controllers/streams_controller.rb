class StreamsController < ApplicationController
  def index
    @streams = Stream.all
    render json: @streams
  end

  def show
    @stream = Stream.find(params[:id])
    render json: @stream
  end
end
