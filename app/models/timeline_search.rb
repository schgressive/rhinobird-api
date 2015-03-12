class TimelineSearch < Struct.new(:params, :current_user)
  def run
    set_basic_scope
    set_search
    set_order
    set_pagination
    search_geo if params.key?(:lat) && params.key?(:lng)

    @scope
  end

  private

  def set_basic_scope
    @scope = if params.key? :user_id
       if current_user && params[:user_id] == "current"
         users = current_user.followed_users.pluck(:id) << current_user.id
         Timeline.where(user_id: users)
       else
         @user = User.find(params[:user_id])
         @user.timelines
       end
    else
      Timeline.where(repost: false)
    end

    @scope = @scope.includes(:resource => :user)
    @scope
  end

  def set_order
    the_order = "promoted DESC, created_at DESC"
    if params.key? :order
      case params[:order]
      when "popular"
        the_order = "likes DESC"
      end
    end
    @scope = @scope.order(the_order)
  end

  def set_search
    @scope = @scope.without_status(:created)
    @scope = @scope.without_status(:pending) unless params.key? :pending
  end

  def set_pagination
    current_page = params[:page] || 1
    @scope = @scope.page(current_page)
    @scope = @scope.per(params[:per_page]) if params.has_key? :per_page
  end

  def search_geo
    @scope = @scope.near([params[:lat], params[:lng]], range)
    @scope
  end

  def range
    @range ||= params.key?(:range) ? params[:range].to_f : 10
  end

end
