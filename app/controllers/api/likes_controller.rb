class Api::LikesController < Api::BaseController
  def create
    resource = Stream.find(params[:stream_id]) if params.key? :stream_id
    Like.track(current_user, resource) if resource
    head 204
  end

  def destroy
    resource = Stream.find(params[:stream_id]) if params.key? :stream_id
    Like.untrack(current_user, resource) if resource
    head 204
  end

end
