class Api::VjsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show]

  def show
    @vj = Vj.find(params[:id])
    respond_with @vj
  end
end
