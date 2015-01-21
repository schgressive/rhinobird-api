class Api::VjsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]
  load_resource find_by: :slug, only: [:update, :show]
  authorize_resource only: [:update]

  def index
    @vjs = VjSearchService.new(params).run
    respond_with @vjs
  end

  def show
    @vj.refresh_live_status
    @vj.increment_playcount!
    respond_with @vj
  end

  def update
    @vj = VjUpdateService.new(@vj, vj_params).run
    respond_with @vj
  end

  def create
    @vj = VjCreateService.new(params, current_user).run
    respond_with @vj
  end

  def destroy
    @vj = current_user.vjs.find(params[:id])
    @vj.destroy

    respond_with @vj
  rescue ActiveRecord::RecordNotFound => e
    render nothing: true, status: 401
  end

  private
  def vj_params
    params.permit(:archived_url, :status, :lat, :lng)
  end
end
