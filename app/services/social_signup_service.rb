class SocialSignupService
  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
    @new_user = false
  end

  def signup
    user = find_for_oauth
    # update profile pic
    if user
      user.update_attributes(photo: @auth.info.image)
      user.update_attributes(fb_token: @auth.credentials.token)
    else
      @new_user = true
      user = new_from_provider
      user.skip_confirmation!
      user.save!
    end

    user
  end

  def new_user?
    @new_user
  end

  private

  def find_for_oauth
    user = User.where(provider: @auth.provider, uid: @auth.uid).first
    user = User.where("email = ? OR username = ?", @auth.info.email, @auth.info.nickname).first unless user
    user
  end

  def new_from_provider
    build_default_hash
    self.send("build_from_#{@auth.provider}")
  end

  def build_default_hash
    @info = {name:@auth.info.name,
             provider:@auth.provider,
             uid:@auth.uid,
             photo: @auth.info.image,
             password:Devise.friendly_token[0,20]
    }
  end

  def build_from_facebook
    User.new(@info.merge({
      email:@auth.info.email,
      fb_token:@auth.credentials.token,
      username: @auth.info.nickname
    }))
  end

  def build_from_twitter
    User.new(@info.merge({
      email:"#{@auth.info.nickname}@twitter.com",
      username: @auth.info.nickname,
      tw_token: @auth.credentials.token,
      tw_secret: @auth.credentials.secret
    }))
  end

  def build_from_google_oauth2
    User.new(@info.merge({
      email: @auth.info.email,
      username: @auth.info.email
    }))
  end
end
