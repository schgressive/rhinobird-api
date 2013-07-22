require 'spec_helper'

describe SessionsController do
  describe "routing" do
    it "routes to #create" do
      expect(post: "/sessions").to route_to("sessions#create")
    end

    it "routes to #destroy" do
      expect(delete: "/sessions").to route_to("sessions#destroy")
    end

  end
end
