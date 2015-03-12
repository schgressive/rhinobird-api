class Api::TimelineController < Api::BaseController
  skip_before_filter :authenticate_user!, only: [:index]
  after_filter only: [:index] { set_pagination_headers(:entries) }

  def index
    @entries = TimelineSearch.new(params, current_user).run
    respond_with @entries
  end

end
