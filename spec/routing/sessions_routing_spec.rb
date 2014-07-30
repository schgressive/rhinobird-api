require 'spec_helper'

describe Api::SessionsController do
  route_prefix = "/v1"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to #create" do
      expect(post: "#{route_prefix}/sessions").to route_to("#{controller_prefix}sessions#create", format: :json)
    end

    it "routes to #show" do
      expect(get: "#{route_prefix}/sessions/current").to route_to("#{controller_prefix}sessions#show", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "#{route_prefix}/sessions/current").to route_to("#{controller_prefix}sessions#destroy", format: :json)
    end

  end
end
