class StreamUpdateService
  def initialize(user, stream, params)
    @user = user
    @params = params
    @stream = stream
  end

  def run
    @stream.attributes = @params
    check_archived_url
    check_stream_id

    @stream.save
    # ignore token for active model serializer
    @stream.ignore_token = true

    share

    @stream
  end

  private

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


  def check_stream_id
    if @params[:stream_id]
      @stream.status = Stream::STATUSES.index(:live)
    end
  end

  def check_archived_url
    if @params[:archived_url] && !@params[:archived_url].empty?
      @stream.status = Stream::STATUSES.index(:archived)
    end
  end
end
