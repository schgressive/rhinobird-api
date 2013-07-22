require 'spec_helper'

describe Api::UsersController do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/users/emilio").to route_to("users#show", id: "emilio", format: :json)
    end
  end
end
