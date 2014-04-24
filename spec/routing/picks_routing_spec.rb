require 'spec_helper'

describe Api::PicksController do
  it "routes to #delete" do
    expect(delete: '/api/picks/123').to route_to("api/picks#destroy", id: "123", format: :json)
  end

  it "routes to #update" do
    expect(put: '/api/picks/123').to route_to("api/picks#update", id: "123", format: :json)
  end

  it "routes to #create" do
    expect(post: '/api/vjs/A1B2/picks').to route_to("api/picks#create", vj_id: "A1B2", format: :json)
  end

end
