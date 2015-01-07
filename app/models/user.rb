class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :async

  devise :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  extend FriendlyId
  friendly_id :username, use: :slugged

  # IMAGES
  has_attached_file :avatar_image, styles: {medium: '60x60'}
  has_attached_file :background_image, styles: {cropped: '1550<'}

  # RELATIONS
  has_many :streams
  has_many :vjs
  has_many :timelines

  def avatar=(value)
    PaperclipHelper.process(value, 'name') do |img|
      self.avatar_image = img
    end
  end

  def backdrop=(value)
    PaperclipHelper.process(value, 'backdrop') do |img|
      self.background_image = img
    end
  end

  def valid_fb_token?
    self.fb_token.present?
  end

  def valid_tw_token?
    self.tw_token.present? && self.tw_secret.present?
  end

  def self.generate_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  # @return [Boolean] user should be remembered when he logs in (with cookie)
  #   so he won't be asked to login again
  def remember_me
    true
  end

end
