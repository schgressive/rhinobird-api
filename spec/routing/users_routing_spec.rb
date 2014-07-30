require 'spec_helper'

describe Api::UsersController do
  route_prefix = "/v1"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to vjs#index" do
      expect(get: "#{route_prefix}/users/emilio/vjs").to route_to("#{controller_prefix}vjs#index", user_id: "emilio", format: :json)
    end

    it "routes to streams#index" do
      expect(get: "#{route_prefix}/users/emilio/streams").to route_to("#{controller_prefix}streams#index", user_id: "emilio", format: :json)
    end

    it "routes to #index" do
      expect(get: "#{route_prefix}/users").to route_to("#{controller_prefix}users#index", format: :json)
    end

    it "routes to #show" do
      expect(get: "#{route_prefix}/users/emilio.black").to route_to("#{controller_prefix}users#show", id: "emilio.black", format: :json)
    end

    it "routes to #create" do
      expect(post: "#{route_prefix}/users").to route_to("#{controller_prefix}users#create", format: :json)
    end

    it "routes to #update" do
      expect(put: "#{route_prefix}/users/profile").to route_to("#{controller_prefix}users#update", id: "profile", format: :json)
    end

  end
end
