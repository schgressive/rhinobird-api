class UserDecorator < Draper::Decorator
  delegate_all

  def applause
    Like.by_user(object).count
  end

  def video_count
    object.streams.count
  end
end
