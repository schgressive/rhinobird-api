class Api::FollowingController < Api::BaseController
  def index
    @user = User.find(params[:user_id])
    @followed_users = @user.followed_users
    respond_with @followed_users, each_serializer: PublicUserSerializer
  end

  def create
    user = User.find(params[:user_id])
    current_user.followed_users << user
    render json: {}, status: 200
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.followed_users.destroy(user)
    render json: {}, status: 200
  end
end
