require 'spec_helper'

describe Api::StreamsPoolController do

  login_user

  describe "GET #index" do
    before do
      @stream = create(:stream)
      @stream_pool = create(:stream_pool, user: @user, stream: @stream)
      get :index, format: :json
      @stream_pools = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns an array of stream pools" do
      expect(@stream_pools).to have(1).items
      expect(@stream_pools[0]["active"]).to eq(@stream_pool.active)
    end

    it "embeds the streams" do
      stream = @stream_pools[0]["stream"]
      expect(stream["id"]).to eq(@stream.to_param)
      expect(stream["caption"]).to eq(@stream.caption)
    end

  end

  describe "POST #create" do

    before do
      @stream = create(:stream)
      post :create, format: :json, stream_id: @stream.id, active: true
      @json= JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "increments the stream pool count" do
      expect{post :create, format: :json, stream_id: @stream.id}.to change(StreamPool, :count).by(1)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns a new stream pool object" do
      expect(@json["active"]).to be_true
      expect(@json["stream"]["id"]).to eq(@stream.to_param)
    end

  end


end
