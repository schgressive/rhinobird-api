class StreamCreateService
  def initialize(user, params)
    @params = params
    @user = user
    @tags = params[:tags]
  end

  def run
    @stream = create_stream
    share

    @stream
  end

  private

  def create_stream
    @stream = @user.streams.create(stream_params)
    @stream.add_tags(@tags) if @tags
    @stream
  end

  # Shares on selected social networks
  def share
    ShareFacebookService.new(@user, @stream).run if @user.valid_fb_token? && share_facebook?
    ShareTwitterService.new(@user, @stream).run if @user.valid_tw_token? && share_twitter?
  end

  def share_facebook?
    (@user.share_facebook && @params[:share_facebook] != false) || @params[:share_facebook]
  end

  def share_twitter?
    (@user.share_twitter && @params[:share_twitter] != false) || @params[:share_twitter]
  end

  def stream_params
    @params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live, :stream_id, :archived_url)
  end

end
