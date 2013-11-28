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
    user = User.where(email: @auth.info.email).first unless user
    user
  end

  def new_from_provider
    self.send("build_from_#{@auth.provider}")
  end

  def build_from_facebook
    User.new(name:@auth.info.name,
                    provider:@auth.provider,
                    uid:@auth.uid,
                    email:@auth.info.email,
                    username: @auth.info.nickname,
                    photo: @auth.info.image,
                    password:Devise.friendly_token[0,20]
                   )
  end

  def build_from_twitter
    User.new(name:@auth.info.name,
                    provider:@auth.provider,
                    uid:@auth.uid,
                    email:"#{@auth.info.nickname}@twitter.com",
                    username: @auth.info.nickname,
                    photo: @auth.info.image,
                    password:Devise.friendly_token[0,20]
                   )
  end

  def build_from_google_oauth2
    User.new(name: @auth.info.name,
             provider: @auth.provider,
             uid: @auth.uid,
             email: @auth.info.email,
             username: @auth.info.email,
             photo: @auth.info.image,
             password:Devise.friendly_token[0,20]
            )
  end
end
