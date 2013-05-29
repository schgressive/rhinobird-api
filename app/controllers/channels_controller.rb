class ChannelsController < ApplicationController

  def index
    @channels = Channel.all
    render json: @channels
  end

  def show
    @channel = Channel.find(params[:id])
    render json: @channel
  end

  def create
    @channel = Channel.create(channel_params)
    render json: @channel, status: :created
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
