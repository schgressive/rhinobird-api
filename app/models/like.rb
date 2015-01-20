class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user

  scope :by_user, -> (user) { where(:user_id => user.id) }
  scope :by_likeable, -> (likeable) { where(:likeable_id => likeable.id, :likeable_type => likeable.class) }

  def self.track(user, likeable)
    like_scope = Like.by_user(user).by_likeable(likeable)
    like_scope.first || like_scope.create
    update_likes likeable
  end


  def self.untrack(user, likeable)
    like = Like.by_user(user).by_likeable(likeable).first
    like.destroy if like
    update_likes likeable
  end

  private

  def self.update_likes(likeable)
    return unless (likeable.respond_to? :likes)
    like_count = Like.by_likeable(likeable).count
    likeable.update_column(:likes, like_count)
  end
end
