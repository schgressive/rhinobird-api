require 'spec_helper'

describe Api::PasswordsController do
  route_prefix = "/v1"
  controller_prefix = "api/"

  describe "routing" do
    it "routes to #create" do
      expect(post: "#{route_prefix}/users/password").to route_to("#{controller_prefix}passwords#create", format: :json)
    end

    it "routes to #put" do
      expect(put: "#{route_prefix}/users/password").to route_to("#{controller_prefix}passwords#update", format: :json)
    end

  end
end

