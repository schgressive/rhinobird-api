class Api::FollowersController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  def index
    @user = User.find(params[:user_id])
    @followers = @user.followers
    respond_with @followers, each_serializer: PublicUserSerializer
  end
end
