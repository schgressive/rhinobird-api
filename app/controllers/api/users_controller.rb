class Api::UsersController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show]

  def show
    user = User.find(params[:id])
    user.show_pool = true
    user.check_vj_status
    respond_with user
  end
end
