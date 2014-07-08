class SocialSignupService
  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
    @new_user = false
  end

  def signup
    user = @current_user || find_for_oauth
    # update profile pic
    if user
      user.update_attributes!(get_update_hash)
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

  def get_update_hash
    self.send("build_from_#{@auth.provider}").reject {|k,v| k == :email || k == :username }
  end

  def find_for_oauth
    user = User.where(provider: @auth.provider, uid: @auth.uid).first
    user = User.where("email = ? OR username = ?", @auth.info.email, @auth.info.nickname).first unless user
    user
  end

  def new_from_provider
    hash = build_default_hash
    hash.merge!(self.send("build_from_#{@auth.provider}"))
    User.new(hash)
  end

  def build_default_hash
    {
      name: @auth.info.name,
      photo: @auth.info.image,
      provider: @auth.provider,
      email: "#{@auth.info.nickname}@twitter.com",
      username: @auth.info.email,
      uid: @auth.uid,
      password: Devise.friendly_token[0,20]
    }
  end

  def build_from_facebook
    {
      email:@auth.info.email,
      fb_token:@auth.credentials.token,
      name: @auth.info.name,
      photo: @auth.info.image,
      username: @auth.info.nickname
    }
  end

  def build_from_twitter
    {
      username: @auth.info.nickname,
      name: @auth.info.name,
      photo: @auth.info.image,
      tw_token: @auth.credentials.token,
      tw_secret: @auth.credentials.secret
    }
  end

  def build_from_google_oauth2
    {
      name: @auth.info.name,
      photo: @auth.info.image,
      email: @auth.info.email
    }
  end
end
