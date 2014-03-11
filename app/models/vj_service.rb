class VjService < SimpleDelegator

  def add(params)
    live_stream = Stream.find(params[:stream_id])

    if live_stream
      set_active_channel(params[:channel_name])

      stream = get_vj_stream(live_stream.id)
      stream ||= create_vj_stream(live_stream.id, params)
    end

    stream || {}
  end

  def remove(stream_id)
    stream = Stream.find(stream_id)
    vj_stream = get_vj_stream(stream.id)

    return false if vj_stream.active && self.stream_pools.count > 1
    vj_stream.destroy

  end

  def update(params)
    stream = Stream.find(params[:id])
    vj_stream = get_vj_stream(stream.id)

    # is it still live?
    if stream.refresh_live_status
      update_vj_stream(vj_stream, params)
    else
      return false
    end
  end

  private

  def update_vj_stream(vj_stream, params)
    active = params[:active]
    audio_active = params[:audio_active]

    update_hash = {active: active}
    update_hash[:connected] = params[:connected] if params.key? :connected
    update_hash[:audio_active] = params[:audio_active] if params.key? :audio_active

    #inactivate other streams
    inactivate_streams if active

    inactivate_audio_streams if audio_active

    vj_stream.update_attributes(update_hash)
    vj_stream
  end

  # inactivates all the other streams
  def inactivate_audio_streams
    self.stream_pools.update_all ['audio_active = ?', false]
  end

  # inactivates all the other streams
  def inactivate_streams
    self.stream_pools.update_all ['active = ?', false]
  end

  def set_active_channel(channel_name)
    empty_vj_session if self.vj_channel_name != channel_name
    self.update_attributes({vj_channel_name: channel_name})
  end

  def empty_vj_session
    self.stream_pools.delete_all
  end

  # returns a stream in the vj session by stream_id
  def get_vj_stream(internal_id)
    self.stream_pools.find_by_stream_id(internal_id)
  end

  def create_vj_stream(internal_id, params)
    self.stream_pools.create!({stream_id: internal_id, connected: params[:connected], active: params[:active]})
  end

end
