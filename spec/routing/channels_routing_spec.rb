require 'spec_helper'

describe ChannelsController do
  describe "routing" do 
    it "routes to #index" do
      expect(get: "/channels").to route_to("channels#index")
    end

    it "doesn't routes to #new" do
      expect(get: "/channels/new").not_to route_to("channels#new")
    end

    it "routes to #streams" do
      expect(get: "/channels/1/streams").to route_to("streams#index", channel_id: "1")
    end

    it "routes to #show" do
      expect(get: "/channels/1").to route_to("channels#show", id: "1")
    end

    it "doesn't routes to #edit" do
      expect(get: "/channels/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "/channels").to route_to("channels#create")
    end

    it "doesn't routes to #update" do
      expect(put: "/channels/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(delete: "/channels/1").to route_to("channels#destroy", :id => "1")
    end

  end
end
