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
    @streams
  end

  private

  def set_basic_scope
    streams = Stream
    streams = Channel.find(@params[:channel_id]).streams if @params.has_key? :channel_id
    streams = User.find(@params[:user_id]).streams if @params.has_key? :user_id
    streams = Stream.where(stream_id: @params[:stream_id]) if @params.has_key? :stream_id
    streams = streams.includes(:user, :channels, :tags).order("streams.created_at DESC")
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
    current_page = @params[:page] || 1
    @streams = @streams.page(current_page)
    @streams = @streams.per(@params[:per_page]) if @params.has_key? :per_page
  end


end
