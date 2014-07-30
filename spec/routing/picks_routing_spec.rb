require 'spec_helper'

describe Api::PicksController do
  it "routes to #delete" do
    expect(delete: '/v1/picks/123').to route_to("api/picks#destroy", id: "123", format: :json)
  end

  it "routes to #update" do
    expect(put: '/v1/picks/123').to route_to("api/picks#update", id: "123", format: :json)
  end

  it "routes to #index" do
    expect(get: '/v1/vjs/A1B2/picks').to route_to("api/picks#index", vj_id: "A1B2", format: :json)
  end

  it "routes to #create" do
    expect(post: '/v1/vjs/A1B2/picks').to route_to("api/picks#create", vj_id: "A1B2", format: :json)
  end

end
