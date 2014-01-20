class BaseSearch

  def initialize(params)
    @params = params
    # basic scope
    @records = set_basic_scope
  end

  def run
    set_search
    set_pagination

    @records
  end

  private

  def set_basic_scope
    records = @model
    records = records.order("#{@searchfield} DESC")
    records
  end

  def set_search

    if @params.key? :q
      q = @params[:q].downcase
      @records = @records.where("#{@searchfield} like ?", "%#{q}%")
    end
  end

  def set_pagination
    current_page = @params[:page] || 1
    @records = @records.page(current_page)
    @records = @records.per(@params[:per_page]) if @params.has_key? :per_page
  end


end
