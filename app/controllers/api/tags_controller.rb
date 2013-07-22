class Api::TagsController < Api::BaseController

  def create
    @stream = Stream.find(params[:stream_id])
    @stream.add_tag(tag_params[:name])
    respond_with :api, @stream, status: :created
  end

  def destroy
    @stream = Stream.find(params[:stream_id])
    @stream.remove_tag(params[:id])
    head :no_content
  end

  private

  def tag_params
    params.permit(:name)
  end
end
