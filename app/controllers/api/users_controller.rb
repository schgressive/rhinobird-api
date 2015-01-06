class Api::UsersController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :create, :index]
  skip_before_filter :require_no_authentication
  skip_before_filter :verify_authenticity_token

  def index
    users = UserSearch.new(params, %w(name username)).run
    respond_with users
  end

  def show
    user = User.find(params[:id])
    respond_with user
  end

  def create
    @user = User.new(resource_params)
    @user.authentication_token = User.generate_token
    if @user.save
      render json: UserSessionSerializer.new(@user), status: :created
    else
      render json: @user.errors, status: 422
    end
  end

  def update
    if current_user.update_attributes(resource_params)
      current_user.confirm!
      render json: current_user, status: 200
    else
      render json: current_user.errors, status: 422
    end
  end

  private
  def resource_params
    params.permit(:name, :email, :password, :password_confirmation, :username, :share_facebook, :share_twitter, :tw_token,
                  :fb_token, :custom_tweet, :enable_custom_tweet, :backdrop, :avatar, :bio)
  end

end
