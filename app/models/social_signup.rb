class SocialSignup
  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
  end

  def signup
    user = find_for_oauth
    unless user
      user = new_from_provider
      user.skip_confirmation!
      user.save!
    end

    user
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
      username: @auth.info.nickname
    }))
  end

  def build_from_twitter
    User.new(@info.merge({
      email:"#{@auth.info.nickname}@twitter.com",
      username: @auth.info.nickname
    }))
  end

  def build_from_google_oauth2
    User.new(@info.merge({
      email: @auth.info.email,
      username: @auth.info.email
    }))
  end
end
