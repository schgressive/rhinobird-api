require 'spec_helper'

describe Api::ChannelsController do
  route_prefix = "/api"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to #index" do
      expect(get: "#{route_prefix}/channels").to route_to("#{controller_prefix}channels#index", format: :json)
    end

    it "doesn't routes to #new" do
      expect(get: "#{route_prefix}/api/channels/new").not_to route_to("#{controller_prefix}channels#new")
    end

    it "routes to #streams" do
      expect(get: "#{route_prefix}/channels/1/streams").to route_to("#{controller_prefix}streams#index", channel_id: "1", format: :json)
    end

    it "routes to #show" do
      expect(get: "#{route_prefix}/channels/1").to route_to("#{controller_prefix}channels#show", id: "1", format: :json)
    end

    it "doesn't routes to #edit" do
      expect(get: "#{route_prefix}/channels/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "#{route_prefix}/channels").to route_to("#{controller_prefix}channels#create", format: :json)
    end

    it "doesn't routes to #update" do
      expect(put: "#{route_prefix}/channels/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(delete: "#{route_prefix}/channels/1").to route_to("#{controller_prefix}channels#destroy", :id => "1", format: :json)
    end

  end
end
