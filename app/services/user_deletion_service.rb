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

    mark_resources(user.streams)
    mark_resources(user.vjs)
  end

  def mark_resources(resources)
    resources.each {|resource| mark_resource resource }
  end

  def mark_resource(resource)
    resource.update_attribute :status, :for_deletion
    resource.timeline.destroy if resource.timeline
  end

end
