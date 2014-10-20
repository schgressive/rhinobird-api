class StreamCreateService
  def initialize(user, params)
    @params = params
    @user = user
    @tags = params[:tags]
  end

  def run
    @stream = create_stream

    @stream
  end

  private

  def create_stream
    @stream = @user.streams.create(stream_params)
    @stream.add_tags(@tags) if @tags
    @stream
  end

  def stream_params
    @params.permit(:caption, :lat, :lng, :geo_reference, :thumb, :live, :stream_id, :archived_url, :archive)
  end

end
