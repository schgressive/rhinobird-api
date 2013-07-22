class Api::ChannelsController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :destroy]

  def index
    @channels = Channel.all
    respond_with :api, @channels
  end

  def show
    @channel = Channel.find_by_name(params[:id])
    respond_with :api, @channel
  end

  def create
    @channel = Channel.create(channel_params)
    respond_with :api, @channel
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    head :no_content
  end

  private

  def channel_params
    params.permit(:name)
  end
end
