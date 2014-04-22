class Api::VjsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show]

  def show
    @vj = Vj.find(params[:id])
    respond_with @vj
  end

  def update
    @vj = current_user.vjs.find(params[:id])
    @vj.update_attributes(vj_params)
    respond_with @vj
  rescue
    render json: {}, status: 404
  end

  private
  def vj_params
    params.permit(:archived_url, :status)
  end
end
