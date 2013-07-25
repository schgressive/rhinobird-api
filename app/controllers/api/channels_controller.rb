class Api::ChannelsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]

  def index
    @channels = Channel.all
    respond_with @channels
  end

  def show
    @channel = Channel.find_by_name(params[:id])
    respond_with @channel
  end

  def create
    @channel = Channel.create(channel_params)
    respond_with @channel
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    respond_with @channel
  end

  private

  def channel_params
    params.permit(:name)
  end
end
