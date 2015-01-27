class Api::FollowersController < Api::BaseController
  def index
    @user = User.find(params[:user_id])
    @followers = @user.followers
    respond_with @followers, each_serializer: PublicUserSerializer
  end
end
