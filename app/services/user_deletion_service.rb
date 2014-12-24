class UserDeletionService

  attr_reader :purge, :user

  def initialize(user, purge: false)
    @purge = purge
    @user = user
  end

  def run
    if purge
      #delete_data
    else
      mark_for_deletion
    end
  end

  def mark_for_deletion
    user.destruction_time = 12.days.from_now
    user.status = :for_deletion
    user.save

    mark_objects(user.streams)
    mark_objects(user.vjs)
  end

  def mark_objects(objects)
    objects.each {|obj| obj.update_attribute :status, :for_deletion }
  end

end
