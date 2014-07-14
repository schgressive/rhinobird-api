class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  devise :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  extend FriendlyId
  friendly_id :username, use: :slugged

  # RELATIONS
  has_many :streams
  has_many :vjs
  has_many :timelines

  def valid_fb_token?
    self.fb_token.present?
  end

  def valid_tw_token?
    self.tw_token.present? && self.tw_secret.present?
  end
end
