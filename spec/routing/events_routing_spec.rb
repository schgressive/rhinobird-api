require 'spec_helper'

describe Api::EventsController do

  it "routes to #index" do
    expect(get: '/v1/vjs/6cb0718db86ea6946c946cbea56b197a/events').to route_to("api/events#index", vj_id: "6cb0718db86ea6946c946cbea56b197a", format: :json)
  end

end
