class StreamCreateService
  def initialize(user, params, tags)
    @params = params
    @user = user
    @tags = tags
  end

  def run
    @stream = create_stream
    share

    @stream
  end

  private

  def create_stream
    @stream = @user.streams.create(@params)
    @stream.add_tags(@tags) if @tags
    @stream
  end

  # Shares on selected social networks
  def share
    share_on_facebook if @user.share_facebook
  end

  def share_on_facebook
    if (@user.fb_token && !@user.fb_token.empty?)
      me = FbGraph::User.me(@user.fb_token)
      me.feed!(
        message: "I'm starting a new live stream",
        picture: @stream.thumbnail.url(:medium),
        description: @stream.caption,
        name: "RhinobirdTv"
      )
    end
  rescue FbGraph::Exception => e
    Rails.logger.info "Couldn't post on facebook: #{e.message}"
  end

end
