class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  protected
  def self.responder
    Responders::JsonResponder
  end
end
