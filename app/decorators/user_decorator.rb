class UserDecorator < Draper::Decorator
  delegate_all

  def applause
    object.streams.sum(:likes) + object.vjs.sum(:likes)
  end

  def playcount
    object.streams.sum(:playcount)
  end

  def video_count
    object.streams.count
  end
end
