class Api::PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    @user=User.send_reset_password_instructions({email: params[:email]})
    if successfully_sent?(@user)
      head status: 200
    else
      render status: 422, json: { errors: @user.errors.full_messages }
    end
  end

  def update
    auth_hash = {reset_password_token: params[:token],
                 password: params[:password],
                 password_confirmation: params[:password_confirmation]}

    @user = User.reset_password_by_token(auth_hash)
    if @user.errors.empty?
      head status: 200
    else
      render status: 422, json: @user.errors
    end
  end
end
