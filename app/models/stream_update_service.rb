class StreamUpdateService
  def initialize(stream, params)
    @params = params
    @stream = stream
  end

  def save
    @stream.attributes = @params
    check_archived_url
    check_stream_id

    @stream.save
    # ignore token for active model serializer
    @stream.ignore_token = true
  end

  private

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
