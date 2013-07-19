require 'spec_helper'

describe StreamsController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/streams").to route_to("streams#index", format: :json)
    end

    it "doesn't routes to #new" do
      expect(get: "/streams/new").not_to route_to("streams#new", format: :json)
    end

    it "routes to #show" do
      expect(get: "/streams/1").to route_to("streams#show", id: "1", format: :json)
    end

    it "doesn't routes to #edit" do
      expect(get: "/streams/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "/streams").to route_to("streams#create", format: :json)
    end

    it "routes to #update" do
      expect(put: "/streams/1").to route_to("streams#update", id: "1", format: :json)
    end

    it "routes to #destroy" do
      expect(delete: "/streams/1").to route_to("streams#destroy", :id => "1", format: :json)
    end

  end
end
