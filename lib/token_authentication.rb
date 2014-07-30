module TokenAuthentication
  private

  def authenticate_user_from_token!
    user_token = request.headers["auth_token"].presence || params[:auth_token].presence
    user       = user_token && User.find_by_authentication_token(user_token.to_s)

    if user
      sign_in user, store: false
      @current_user = user
    end
  end

end
