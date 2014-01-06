class StreamUpdateService
  def initialize(stream, params)
    @params = params
    @stream = stream
  end

  def save
    @stream.attributes = @params
    check_archived_url

    @stream.save
    # ignore token for active model serializer
    @stream.ignore_token = true
  end

  private

  def check_archived_url
    if @params[:archived_url] && !@params[:archived_url].empty?
      @stream.status = Stream::STATUSES.index(:archived)
    end
  end
end
