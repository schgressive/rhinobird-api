require 'spec_helper'

describe UsersController do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/users/emilio").to route_to("users#show", id: "emilio")
    end
  end
end
