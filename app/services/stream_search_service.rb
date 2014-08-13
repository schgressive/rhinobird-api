class StreamSearchService

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
    streams = streams.includes(:user, :channels, :tags).order("streams.promoted DESC, streams.created_at DESC")
    streams = streams.without_status(:created)
    streams
  end

  def set_search

    search_geo
    search_status
    search_by_channels_in_caption

    if @params.key? :q
      q = @params[:q].downcase
      @streams = @streams.where("(lower(concat_ws(',', caption, address, country, city)) like ? OR users.username = ?)", "%#{q}%", q)
    end
  end

  def search_status
    conditions = []
    conditions << :live if @params.has_key? :live
    conditions << :archived if @params.has_key? :archived
    conditions << :pending if @params.has_key? :pending

    @streams = @streams.with_status(*conditions) unless conditions.empty?
    @streams
  end

  def search_by_channels_in_caption
    if @params.key?(:id) && @params["action"] == "related"
      stream = Stream.find(@params[:id])
      channels = Channel.get_channels(stream.caption).map {|c| c.name}
      unless channels.empty?
        @streams = @streams.where("match(caption) against(?) AND hash_token <> ? ", channels.join(","), @params[:id])
      end
    end
  end

  def search_geo
    if @params.key?(:lat) && @params.key?(:lng)
      range = @params[:range] ? @params[:range].to_f : 1
      @streams = @streams.near([@params[:lat], @params[:lng]], range)
    end
  end

  def set_pagination
    current_page = @params[:page] || 1
    @streams = @streams.page(current_page)
    @streams = @streams.per(@params[:per_page]) if @params.has_key? :per_page
  end


end
