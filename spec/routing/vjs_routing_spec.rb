require 'spec_helper'

describe Api::VjsController do

  it "routes to #index" do
    expect(get: '/api/vjs/6cb0718db86ea6946c946cbea56b197a').to route_to("api/vjs#show", id: "6cb0718db86ea6946c946cbea56b197a", format: :json)
  end

  it "routes to #create" do
    expect(post: '/api/vjs').to route_to("api/vjs#create", format: :json)
  end

  it "routes to #index" do
    expect(get: '/api/vjs').to route_to("api/vjs#index", format: :json)
  end

  it "routes to #update" do
    expect(put: '/api/vjs/6cb0718db86ea6946c946cbea56b197a').to route_to("api/vjs#update", id: "6cb0718db86ea6946c946cbea56b197a", format: :json)
  end

    it "routes to #index" do
      expect(get: "/api/streams/1/vjs").to route_to("api/vjs#index", stream_id: "1", format: :json)
    end

end
