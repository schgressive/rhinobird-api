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
    @user = SocialSignup.new(auth, user).signup

    if @user.persisted?
      sign_in @user
    end
    redirect_to "http://#{ENV["PUBLIC_HOST"]}/profile/edit?complete=#{from}"
  end

end
