class Api::FollowingController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  def index
    @user = User.find(params[:user_id])
    @followed_users = @user.followed_users
    respond_with @followed_users, each_serializer: PublicUserSerializer
  end

end
