class ChannelSearch < Struct.new(:params)

  def run
    set_basic_scope
    set_search
    set_order
    set_pagination unless params.key?(:lat) && !params.key?(:order)
    search_geo if params.key?(:lat) && params.key?(:lng)

    @records
  end

  private

  def set_basic_scope
    @records = Channel.includes(:streams)
    @records
  end

  def set_order
    the_order = "name DESC"
    if params.key? :order
      case params[:order]
      when "latest"
        the_order = "created_at DESC"
      when "popular"
        the_order = "stream_likes DESC"
      end
    end
    @records = @records.order(the_order)
  end

  def set_search

    if params.key? :q
      q = params[:q].downcase
      @records = @records.where("lower(name) like ?", "%#{q}%")
    end
  end

  def set_pagination
    current_page = params[:page] || 1
    @records = @records.page(current_page)
    @records = @records.per(params[:per_page]) if params.has_key? :per_page
  end

  def search_geo


    if params.key? :order
      @record = @records
        .where(streams: {id: near_streams})
        .select("DISTINCT(channels.id), channels.*")
    else
      @new = @records
        .where(streams: {id: near_streams})
        .reorder("channels.created_at DESC")

      @popular = @records.joins(:streams)
        .where(streams: {id: near_streams})
        .reorder("count(channels.id) DESC")
        .group("channels.id, channels.name, channels.created_at")

      @records = @popular.zip(@new).flatten.compact.uniq
    end
    @records
  end

  def range
    @range ||= params.key?(:range) ? params[:range].to_f : 10
  end

  # Returns the stream ids near the location
  def near_streams
    Stream.where("caption is not null AND caption <> ''").near([params[:lat], params[:lng]], range).pluck(:id)
  end
end
