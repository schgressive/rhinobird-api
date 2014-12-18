class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  scope :by_user, -> (user) { where(:user_id => user.id) }
  scope :by_likeable, -> (likeable) { where(:likeable_id => likeable.id, :likeable_type => likeable.class) }

  def self.track(user, likeable)
    like_scope = Like.by_user(user).by_likeable(likeable)
    like_scope.first || like_scope.create
  end
end
