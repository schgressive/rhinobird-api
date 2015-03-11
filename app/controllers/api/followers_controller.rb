class Api::FollowersController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  def index
    @user = User.find(params[:user_id])
    @followers = @user.followers
    respond_with @followers
  end

  def create
    user = User.find(params[:user_id])
    user.followers << current_user
    respond_with current_user
  end

  def destroy
    user = User.find(params[:user_id])
    user.followers.destroy(current_user)
    render json: {}, status: 200
  end
end
