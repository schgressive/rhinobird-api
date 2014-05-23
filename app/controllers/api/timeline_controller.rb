class Api::TimelineController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  after_filter only: [:index] { set_pagination_headers(:entries) }

  def index
    @entries = if params.has_key? :user_id
      @user = User.find params[:user_id]
      @user.timelines
    else Timeline end

    @entries = @entries.includes(:resource => :user).order('created_at DESC')
    @entries = @entries.page(params[:page] || 1)
    @entries = @entries.per(params[:per_page]) if params.has_key? :per_page

    respond_with @entries.all
  end

end
