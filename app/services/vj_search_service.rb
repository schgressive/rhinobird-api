class VjSearchService
  def initialize(params)
    @params = params
    # basic scope
    @records = set_basic_scope
  end

  def run
    search_by_channel
    search_by_status
    set_pagination

    @records
  end

  private

  def set_basic_scope
    records = Vj
    records
  end

  def search_by_status
    if @params.key? :status
      @records = @records.with_status(@params[:status])
    end
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
