require 'spec_helper'

describe ChannelsController do

  before do
    @channel = FactoryGirl.create(:channel)
  end

  context "GET index" do
    before do
      get :index
      @channels = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns an array of channels" do
      expect(@channels).to have(1).items
      expect(@channels[0]["id"]).to eq(@channel.id)
      expect(@channels[0]["identifier"]).to eq(@channel.identifier)
    end
    
  end

end
