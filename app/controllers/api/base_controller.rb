class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  protected
  def self.responder
    Responders::JsonResponder
  end

  def set_pagination_headers(name)
    scope = instance_variable_get("@#{name}")
    headers["X-Page-Total"] = scope.total_pages.to_s
    headers["X-Page"] = scope.current_page.to_s
  end

end
