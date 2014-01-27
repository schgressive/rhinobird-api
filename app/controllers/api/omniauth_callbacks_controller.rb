class  Api::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    process_omniauth(request.env["omniauth.auth"], current_user, "facebook")
  end

  def twitter
    process_omniauth(request.env["omniauth.auth"], current_user, "twitter")
  end

  def google_oauth2
    process_omniauth(request.env["omniauth.auth"], current_user, "google")
  end

  private

  def process_omniauth(auth, user, from)
    social = SocialSignup.new(auth, user)
    @user = social.signup
    sign_in @user

    route = "#{ENV["HOST_PROTOCOL"]}://#{ENV["PUBLIC_HOST"]}"
    route += "/profile/edit/?complete=#{from}" if social.new_user?
    redirect_to route
  end

end
