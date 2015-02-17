class Api::RepostsController < Api::BaseController

  def create
    original = Stream.find(params[:stream_id]) if params[:stream_id]
    original = Vj.find(params[:vj_id]) if params[:vj_id]
    @resource = RepostResourceService.new(original, current_user).run
    respond_with @resource
  end

end
