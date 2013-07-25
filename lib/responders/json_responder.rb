module Responders

  class JsonResponder < ActionController::Responder
    protected

    # simply render the resource on PUT request
    def api_behavior(error)
      if post?
        display resource, :status => :created
      elsif put?
        display resource, :status => :ok
      else
        super
      end
    end

  end

end
