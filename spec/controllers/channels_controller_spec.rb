require 'spec_helper'

describe ChannelsController do

  describe "GET #index" do
    before do
      @channel = create(:channel)
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
      expect(@channels[0]["id"]).to eq(@channel.hash_token)
      expect(@channels[0]["name"]).to eq(@channel.name)
    end

  end

  describe "GET #show" do
    before do
      @new_channel = create(:channel, streams: [create(:stream)])
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
      expect(@json_channel["id"]).to eq(@new_channel.hash_token)
      expect(@json_channel["name"]).to eq(@new_channel.name)
      expect(@json_channel["created_at"]).to eq(@new_channel.created_at.to_s(:api))
      expect(@json_channel["streams_count"]).to eq(@new_channel.streams.count)
      expect(@json_channel["streams"]).to have(1).items

      stream = @json_channel["streams"].first
      expect(stream["title"]).not_to be_empty
      expect(stream["id"]).not_to be_empty
      expect(stream["channels"]).not_to be_empty
    end

  end

  describe "POST #create" do

    before do
      @post_hash = {name: 'MyNewChannel123'}

      post :create, @post_hash
      @json_channel = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "increments the channel count" do
      expect{post :create, {name: 'Testchannelcreation'}}.to change(Channel, :count).by(1)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns a new channel object" do
      expect(@json_channel["id"]).not_to be("")
      expect(@json_channel["name"]).to eq(@post_hash[:name])
      expect(@json_channel["streams"]).to eq([])
      expect(@json_channel["streams_count"]).to eq(0)
      expect(@json_channel["created_at"]).not_to be_empty
    end

  end

  describe "DELETE #destroy" do
    before do
      @delete_channel = create(:channel)
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
