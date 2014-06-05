class VjSearchService
  def initialize(params)
    @params = params
    # basic scope
    @records = set_basic_scope
  end

  def run
    search_by_channel
    filter_by_username
    filter_by_stream
    search_by_status
    set_pagination

    @records
  end

  private

  def set_basic_scope
    records = Vj
    records
  end


  def filter_by_stream
    if @params.key? :stream_id
      stream_id = Stream.find(@params[:stream_id]).id
      @records = @records.includes(:events).where(events: {stream_id: stream_id})
    end
  end

  def filter_by_username
    if @params.key? :user_id
      user_id = User.find(@params[:user_id]).id
      @records = @records.where(user_id: user_id)
    end
  end

  def search_by_status
    statuses = Vj.status.values.select {|v| @params.has_key? v.to_sym }
    @records = @records.with_status(*statuses) unless statuses.empty?
  end


  def search_by_channel
    if @params.key? :channel_name
      channel = Channel.find(@params[:channel_name])
      @records = @records.where(channel_id: channel.id)
    end
  end

  def set_pagination
    current_page = @params[:page] || 1
    @records = @records.page(current_page)
    @records = @records.per(@params[:per_page]) if @params.has_key? :per_page
  end


end
