class Api::TimelineController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  after_filter only: [:index] { set_pagination_headers(:entries) }

  def index
    @entries = if params.key? :user_id
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

    @entries = @entries.includes(:resource => :user).order('promoted DESC, created_at DESC')
    @entries = @entries.page(params[:page] || 1)
    @entries = @entries.per(params[:per_page]) if params.key? :per_page
    @entries = @entries.without_status(:created)
    @entries = @entries.without_status(:pending) unless params.key? :pending

    respond_with @entries
  end

end
