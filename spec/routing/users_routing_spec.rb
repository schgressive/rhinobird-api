require 'spec_helper'

describe Api::UsersController do
  route_prefix = "/api"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to streams_pool#index" do
      expect(get: "#{route_prefix}/users/emilio/streams_pool").to route_to("#{controller_prefix}streams_pool#index", user_id: "emilio", format: :json)
    end

    it "routes to streams#index" do
      expect(get: "#{route_prefix}/users/emilio/streams").to route_to("#{controller_prefix}streams#index", user_id: "emilio", format: :json)
    end

    it "routes to #show" do
      expect(get: "#{route_prefix}/users/emilio").to route_to("#{controller_prefix}users#show", id: "emilio", format: :json)
    end

    it "routes to #create" do
      expect(post: "#{route_prefix}/users").to route_to("#{controller_prefix}users#create", format: :json)
    end

  end
end
