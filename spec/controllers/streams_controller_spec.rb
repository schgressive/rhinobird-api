require 'spec_helper'

describe StreamsController do

  before do
    @stream = create(:stream)
  end

  describe "GET #index" do
    context "without a channel" do
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

    context "with a channel" do
      before do
        create(:stream)
        @channel = create(:channel, streams: [create(:stream), create(:stream)])
        get :index, channel_id: @channel.id
        @streams = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "returns the streams related to this channel" do
        expect(@streams).to have(2).items
      end
    end

  end

  context "POST #create" do

    before(:each) do
      File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
        @image_base64 = "data:image/jpg;base64,#{file.read}"
      end

      @post_hash = {title: 'stream from POST JSON',
                    desc: "Test POST", lat: -25.272062301637, lng: -57.585376739502,
                    geo_reference: 'Unkown location',
                    thumb: @image_base64}

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
      expect(@json_stream["channel"]).to be_empty
    end

    it "returns a thumb information" do
      expect(@json_stream["thumbs"]["small"]).to match(/^http:\/\/.*thumb.jpg/)
      expect(@json_stream["thumbs"]["medium"]).to match(/^http:\/\/.*thumb.jpg/)
      expect(@json_stream["thumbs"]["large"]).to match(/^http:\/\/.*thumb.jpg/)
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([@post_hash[:lng], @post_hash[:lat]])
      expect(@json_stream["properties"]["geo_reference"]).to eq(@post_hash[:geo_reference])
    end

  end

  context "GET #show" do
    before do
      File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
        @image_base64 = "data:image/jpg;base64,#{file.read}"
      end

      @channel = create(:channel)
      @new_stream = create(:stream, lat: -25.272062301637, lng: -57.585376739502, id: "123", channel: @channel, thumb: @image_base64)
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
      expect(@json_stream["thumbs"]["small"]).to match(/^http:\/\/.*thumb.jpg/)
      expect(@json_stream["thumbs"]["medium"]).to match(/^http:\/\/.*thumb.jpg/)
      expect(@json_stream["thumbs"]["large"]).to match(/^http:\/\/.*thumb.jpg/)
      expect(@json_stream["channel"]["id"]).to eq(@channel.to_param)
      expect(@json_stream["channel"]["name"]).to eq(@channel.name)
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([@new_stream.lng.to_f, @new_stream.lat.to_f])
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
