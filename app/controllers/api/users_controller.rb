class Api::UsersController < Api::BaseController

  def show
    user = User.find(params[:id])
    respond_with :api, user
  end
end
