require 'spec_helper'

describe ChannelsController do

  context "GET index" do
    before do
      @channel = FactoryGirl.create(:channel)
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

  context "GET channel" do
    before do
      @new_channel = FactoryGirl.create(:channel, streams: [FactoryGirl.create(:stream)])
      get :show, id: @new_channel.id
      @json_channel = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns correct json structure" do 
      expect(@json_channel["id"]).to eq(@new_channel.id)
      expect(@json_channel["identifier"]).to eq(@new_channel.identifier)
      expect(@json_channel["created_at"]).to eq(@new_channel.created_at.strftime("%Y-%m-%dT%H:%M:%S.000"))
      expect(@json_channel["streams"]).to eq(@new_channel.streams.map(&:id))
      expect(@json_channel["streams_count"]).to eq(@new_channel.streams.count)
    end

  end

  context "CREATE channel" do
    
    before do
      @post_hash = {identifier: 'Hello from JSON'}

      post :create, @post_hash
      @json_channel = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "increments the channel count" do
      expect{post :create, @post_hash}.to change(Channel, :count).by(1)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns a new channel object" do 
      expect(@json_channel["id"]).not_to be("")
      expect(@json_channel["identifier"]).to eq(@post_hash[:identifier])
      expect(@json_channel["streams"]).to eq([])
      expect(@json_channel["streams_count"]).to eq(0)
    end

  end

  context "DELETE channel" do
    before do 
      @delete_channel = FactoryGirl.create(:channel) 
    end

    it "returns no content status" do
      delete :destroy, id: @delete_channel.id
      expect(response.status).to be(204)
    end

    it "decreses the channel count" do 
      expect{delete :destroy, id: @delete_channel.id}.to change(Channel, :count).by(-1)
    end

  end



end
