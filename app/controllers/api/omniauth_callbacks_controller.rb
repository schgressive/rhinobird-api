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
    social = SocialSignupService.new(auth, user)
    @user = social.signup
    sign_in @user

    oauth_params = request.env["omniauth.params"]
    # if we're using a popup close the window
    if oauth_params["popup"]
      render content_type: 'text/html', inline: "<script>window.close();</script>"
    else
      route = "#{ENV["HOST_PROTOCOL"]}://#{ENV["PUBLIC_HOST"]}"
      route += "/profile/edit/?complete=#{from}" if social.new_user?
      redirect_to route
    end

  end

end
