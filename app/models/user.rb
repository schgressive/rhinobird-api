class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable#, :confirmable

  validates :name, :username, presence: true
  validates :username, uniqueness: true

  extend FriendlyId
  friendly_id :username

  # RELATIONS
  has_many :streams
  has_many :stream_pools

  # returns true if it acts as a VJ
  def vj?
    !self.stream_pools.empty?
  end
end
