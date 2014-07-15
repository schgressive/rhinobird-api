class ShareFacebookService

  def initialize(user, stream)
    @stream = stream
    @user = user
  end

  def run
    me = FbGraph::User.me(@user.fb_token)
    me.feed!(
      message: "I'm starting a new live stream",
      picture: @stream.thumbnail.url(:medium),
      description: @stream.caption,
      link: @stream.full_stream_url,
      name: "RhinobirdTv"
    )
  rescue FbGraph::Exception => e
    Rails.logger.info "Couldn't post on facebook: #{e.message}"
  end

end
