class VjCreateService

  def initialize(params, user)
    @params = params
    @user = user
  end

  def run
    @channel = Channel.find(@params[:channel_name])
    set_pending_other_vjs
    @vj = create_vj
    @vj
  end

  private

  def set_pending_other_vjs
    @user.vjs.where(channel_id: @channel.id).update_all(status: Vj.status.find_value(:pending).value)
  end

  def create_vj
    vj = @user.vjs.new
    vj.channel = @channel
    vj.status = @params[:status].to_sym if @params.key?(:status)
    vj.save
    vj
  end

end
