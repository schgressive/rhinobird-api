class StreamsController < ApplicationController
  def index
    @streams = Stream.all
    render json: @streams
  end
end
