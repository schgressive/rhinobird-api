class ChannelSearch < BaseSearch
  def run
    search_geo
    super
  end

  private
  def search_geo
    if @params.key?(:lat) && @params.key?(:lng)
      range = @params.key?(:range) ? @params[:range].to_f : 10
      streams_ids = Stream.where("caption is not null AND caption <> ''").near([@params[:lat], @params[:lng]], range).pluck(:id)
      @records = @records.joins(:streams).where(streams: {id: streams_ids}).uniq
    end
  end
end
