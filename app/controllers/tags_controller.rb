class TagsController < ApplicationController

  def create
    @stream = Stream.find(tag_params[:stream_id])
    @stream.add_tag(tag_params[:name])
    render json: @stream, status: :created
  end

  private

  def tag_params
    params.permit(:name, :stream_id)
  end
end
