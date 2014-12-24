class Api::LikesController < Api::BaseController
  def create
    Like.track(current_user, resource) if resource
    head 204
  end

  def destroy
    Like.untrack(current_user, resource) if resource
    head 204
  end

  private

  def resource
    @resource = nil
    unless @resource
      @resource = Stream.find(params[:stream_id]) if params[:stream_id]
      @resource = Vj.find(params[:vj_id]) if params[:vj_id]
    end
    @resource
  end

end
