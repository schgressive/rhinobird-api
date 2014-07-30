require 'spec_helper'

describe Api::StreamsController do
  route_prefix = "/v1"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to #index" do
      expect(get: "#{route_prefix}/streams").to route_to("#{controller_prefix}streams#index", format: :json)
    end

    it "doesn't routes to #new" do
      expect(get: "#{route_prefix}/streams/new").not_to route_to("#{controller_prefix}streams#new", format: :json)
    end

    it "routes to #show" do
      expect(get: "#{route_prefix}/streams/1").to route_to("#{controller_prefix}streams#show", id: "1", format: :json)
    end

    it "doesn't routes to #edit" do
      expect(get: "#{route_prefix}/streams/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "#{route_prefix}/streams").to route_to("#{controller_prefix}streams#create", format: :json)
    end

    it "routes to #update" do
      expect(put: "#{route_prefix}/streams/1").to route_to("#{controller_prefix}streams#update", id: "1", format: :json)
    end

    it "routes to #play" do
      expect(put: "#{route_prefix}/streams/1/play").to route_to("#{controller_prefix}streams#play", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "#{route_prefix}/streams/1").to route_to("#{controller_prefix}streams#destroy", :id => "1", format: :json)
    end

  end
end
