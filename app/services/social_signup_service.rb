class SocialSignupService
  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
    @new_user = false
    @invalid_fields = []
  end

  def signup
    user = @current_user || find_for_oauth

    if user
      user.update_attributes!(data_for_update)
    else
      @new_user = true
      user = User.new(data_for_create)
      user.incomplete_fields = @invalid_fields.join(",")
      user.skip_confirmation!
    end

    # Set auth token
    user.authentication_token = User.generate_token
    user.save!

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

  def data_for_create
    hash = {
      email: email,
      username: username,
      photo: @auth.info.image,
      name: @auth.info.name,
      provider: @auth.provider,
      uid: @auth.uid,
      password: Devise.friendly_token[0,20]
    }.merge!(auth_info)

    hash
  end

  def data_for_update
    data_for_create.reject {|k,v| k == :email || k == :username || k == :password }
  end

  def email
    email = @auth.info.email
    if email.nil?
      @invalid_fields << :email
      email = "#{username}@invalid.address"
    end
    email
  end

  def username
    username = @auth.info.nickname
    if username.nil?
      @invalid_fields << :username
      username = generate_rhinobird_username
    end
    username
  end

  # Generates a RhinobirdUser23 free username
  def generate_rhinobird_username
    loop do
      username = "RhinobirdUser#{rand(9999999)}"
      break username unless User.find_by_username(username)
    end
  end

  # Returns the auth tokens for the social network
  def auth_info
    info = {}
    info.merge!(tw_token: @auth.credentials.token, tw_secret: @auth.credentials.secret) if @auth.provider == "twitter"
    info.merge!(fb_token: @auth.credentials.token) if @auth.provider == "facebook"
    info
  end

end
