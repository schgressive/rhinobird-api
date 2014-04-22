require 'spec_helper'

describe Api::VjsController do

  it "routes to #index" do
    expect(get: '/api/vjs/6cb0718db86ea6946c946cbea56b197a').to route_to("api/vjs#show", id: "6cb0718db86ea6946c946cbea56b197a", format: :json)
  end

  it "routes to #update" do
    expect(put: '/api/vjs/6cb0718db86ea6946c946cbea56b197a').to route_to("api/vjs#update", id: "6cb0718db86ea6946c946cbea56b197a", format: :json)
  end
end
