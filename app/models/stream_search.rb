class StreamSearch

  def initialize(params)
    @params = params
    # basic scope
    @streams = set_basic_scope
  end

  def run
    set_search
    set_pagination

    @streams.reject! { |stream| stream.refresh_live_status == false } if @params.has_key? :force_check
    @streams.all
  end

  private

  def set_basic_scope
    streams = Stream
    if @params.has_key? :channel_id
      streams = Channel.find(@params[:channel_id]).streams
    end
    streams = streams.includes(:user, :channels, :tags).order("created_at DESC")
    streams
  end

  def set_search

    search_geo

    @streams = @streams.where(live: true) if @params.has_key? :live
    if @params.key? :q
      q = @params[:q].downcase
      @streams = @streams.joins(:user)
      @streams = @streams.where("(lower(concat_ws(',', caption, geo_reference)) like ? OR users.username = ?)", "%#{q}%", q)
    end
  end

  def search_geo
    if @params.key?(:lat) && @params.key?(:lng)
      range = @params[:range]
      range = range ? range.to_f : 1
      @streams = @streams.near([@params[:lat], @params[:lng]], @params[:range].to_f)
    end
  end

  def set_pagination
    @streams = @streams.offset(@params[:offset]) if @params.has_key? :offset
    @streams = @streams.limit(@params[:limit]) if @params.has_key? :limit
  end


end
