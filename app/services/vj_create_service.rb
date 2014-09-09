class VjCreateService

  def initialize(params, user)
    @params = params
    @user = user
  end

  def run
    set_pending_other_vjs
    @vj = create_vj
    @vj
  end

  private

  def set_pending_other_vjs
    @user.vjs.where(channel_id: channel.id).without_status(:pending).each do |vj|
      vj.update_attributes(status: :pending)
    end
  end

  def create_vj
    @params[:channel_id] = channel.id
    @user.vjs.create(vj_params)
  end

  def vj_params
    @params.permit(:archived_url, :status, :lat, :lng, :channel_id)
  end

  def channel
    @channel ||= Channel.find(@params[:channel_name])
  end

end
