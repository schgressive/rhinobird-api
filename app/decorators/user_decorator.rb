class UserDecorator < Draper::Decorator
  delegate_all

  def applause
    object.likes
  end

  def playcount
    object.streams.sum(:playcount)
  end

  def video_count
    object.streams.count
  end
end
