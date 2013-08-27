class StreamPool < ActiveRecord::Base
  # Relations
  belongs_to :stream
  belongs_to :user

  # Validations
  validates :user_id, :stream_id, presence: true

  def self.get_by_stream_hash(user, stream_hash)
    stream = Stream.find(stream_hash)
    user.stream_pools.find_by_stream_id(stream.id)
  end

  def set_active(active)
    return false unless stream.refresh_live_status

    # inactivate other streams
    inactivate_streams if active

    self.update_attributes active: active
    true
  end

  def self.add_to_pool(user, stream_id, params)
    stream_pool = StreamPool.get_by_stream_hash(user, stream_id)
    if stream_pool.nil?
      stream = Stream.find(stream_id)
      params[:stream_id] = stream.id
      stream_pool = user.stream_pools.create(params)
    end
    stream_pool
  end

  # removes the stream unless is active
  def remove_from_pool
    return false if self.active && self.user.stream_pools.count > 1

    self.destroy
    true
  end

  private
  # inactivates all the other streams
  def inactivate_streams
    StreamPool.update_all ['active = ?', false], ['user_id = ?', self.user_id]
  end
end
