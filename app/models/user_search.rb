class UserSearch < Struct.new(:params)

  def run
    set_basic_scope
    set_search
    set_order
    set_pagination

    @scope
  end

  private

  def set_basic_scope
    @scope = User
    @scope
  end

  def set_order
    the_order = "name DESC"
    if params.key? :order
      case params[:order]
      when "popular"
        the_order = "likes DESC"
      end
    end
    @scope = @scope.order(the_order)
  end

  def set_search

    if params.key? :q
      q = params[:q].downcase
      @scope = @scope.where("lower(name) like ?", "%#{q}%")
    end
  end

  def set_pagination
    current_page = params[:page] || 1
    @scope = @scope.page(current_page)
    @scope = @scope.per(params[:per_page]) if params.has_key? :per_page
  end

end
