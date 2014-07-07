class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  rescue_from 'ActiveRecord::RecordNotFound' do |exc|
    respond_with_error :not_found, 'not found'
  end
  # Canned error support
  rescue_from 'CanCan::AccessDenied' do |exc|
    respond_with_error :unauthorized, 'not authorized'
  end

  def respond_with_error(_code, _message, _data=nil)
    error_obj = { error: _message };
    error_obj[:data] = _data if _data

    respond_with do |format|
      format.json { render :status => _code, :json => error_obj }
    end
  end

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
