require 'spec_helper'

describe StreamsController do

  before do
    @stream = FactoryGirl.create(:stream)
  end

  context "GET index" do
    before do
      get :index
      @streams = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns an array of items" do
      expect(@streams).to have(1).items
      expect(@streams[0]["id"]).to eq(@stream.id)
      expect(@streams[0]["title"]).to eq(@stream.title)
    end
    
  end

end
