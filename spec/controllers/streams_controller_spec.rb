require 'spec_helper'

describe StreamsController do

  before do
    @stream = create(:stream)
  end

  context "GET #index" do
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
      expect(@streams[0]["id"]).to eq(@stream.to_param)
      expect(@streams[0]["title"]).to eq(@stream.title)
    end

  end

  context "POST #create" do

    before do
      @post_hash = {title: 'stream from POST JSON', desc: "Test POST", lat: -25.2720623016357, lng: -57.585376739502, geo_reference: 'Unkown location'}

      post :create, @post_hash
      @json_stream = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns a new stream object" do
      expect(@json_stream["title"]).to eq(@post_hash[:title])
      expect(@json_stream["desc"]).to eq(@post_hash[:desc])
      expect(@json_stream["id"]).not_to be("")
      expect(@json_stream["channels"]).to eq([])
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([@post_hash[:lat], @post_hash[:lng]])
      expect(@json_stream["properties"]["geo_reference"]).to eq(@post_hash[:geo_reference])
    end

  end

  context "GET #show" do
    before do
      @new_stream = create(:stream, lat: -25.2720623016357, lng: -57.585376739502, id: "123", channels: [create(:channel)])
      get :show, id: @new_stream.id
      @json_stream = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns correct stream format" do
      expect(@json_stream["id"]).to eq(@new_stream.to_param)
      expect(@json_stream["title"]).to eq(@new_stream.title)
      expect(@json_stream["desc"]).to eq(@new_stream.desc)
      expect(@json_stream["started_on"]).to eq(@new_stream.started_on.to_s(:api))
      expect(@json_stream["channels"]).to eq(@new_stream.channels.map(&:to_param))
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([-25.272062301636, -57.585376739502])
      expect(@json_stream["properties"]["geo_reference"]).to eq(@new_stream.geo_reference)
    end

  end

  context "DELETE #destroy" do
    before do
      @delete_stream = create(:stream)
    end

    it "returns no content status" do
      delete :destroy, id: @delete_stream.id
      expect(response.status).to be(204)
    end

    it "decreses the stream count" do
      expect{delete :destroy, id: @delete_stream.id}.to change(Stream, :count).by(-1)
    end

  end


end
