class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  protected
  def self.responder
    Responders::JsonResponder
    # lambda do |controller, resources, options|
    #   if true
    #     Responders::JsonResponder.call(controller, resources, options)
    #   else
    #     super.call(controller, resources, options)
    #   end
    # end
  end
end
