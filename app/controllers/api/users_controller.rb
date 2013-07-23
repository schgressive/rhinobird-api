class Api::UsersController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show]

  def show
    user = User.find(params[:id])
    respond_with :api, user
  end
end
