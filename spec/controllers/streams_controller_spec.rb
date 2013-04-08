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

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns an array of items" do
      expect(@streams).to have(1).items
      expect(@streams[0]["id"]).to eq(@stream.id)
      expect(@streams[0]["title"]).to eq(@stream.title)
    end
    
  end

  context "GET :ID" do
    before do
      @new_stream = FactoryGirl.create(:stream, lat: -12.123456, lng: -20.654321, id: "123")
      get :show, id: @new_stream.id
      @json_stream = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns correct stream data" do 
      expect(@json_stream["id"]).to eq(@new_stream.id)
      expect(@json_stream["title"]).to eq(@new_stream.title)
      expect(@json_stream["desc"]).to eq(@new_stream.desc)
      expect(@json_stream["geo_reference"]).to eq(@new_stream.geo_reference)
      expect(@json_stream["started_on"]).to eq(@new_stream.started_on.strftime("%Y-%m-%dT%H:%M:%S.%3N"))
      expect(@json_stream["lat"]).to eq(-12.123456)
      expect(@json_stream["lng"]).to eq(-20.654321)
      expect(@json_stream["channels"]).to eq([])
    end

  end

end
