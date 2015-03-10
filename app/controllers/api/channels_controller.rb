class Api::ChannelsController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:show, :index]
  after_filter only: [:index] { set_pagination_headers(:channels) }

  def index
    @channels = ChannelSearch.new(params).run
    respond_with @channels
  end

  def show
    @channel = Channel.find(params[:id])
    respond_with @channel
  rescue
    render nothing: true, status: 404
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
