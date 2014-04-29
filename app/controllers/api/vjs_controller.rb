class Api::VjsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]
  load_resource find_by: :slug, only: [:update, :show]
  authorize_resource only: [:update]

  def index
    @vjs = VjSearchService.new(params).run
    respond_with @vjs
  end

  def show
    respond_with @vj
  end

  def update
    @vj.update_attributes(vj_params)
    respond_with @vj
  end

  def create
    @vj = VjCreateService.new(params, current_user).run
    respond_with @vj
  end

  private
  def vj_params
    params.permit(:archived_url, :status)
  end
end
