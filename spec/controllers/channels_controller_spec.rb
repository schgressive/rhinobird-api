require 'spec_helper'

describe Api::ChannelsController do

  describe "GET #index" do
    context "basic" do
      before do
        @channel = create(:channel)
        get :index, format: :json
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
        expect(@channels[0]["name"]).to eq(@channel.name)
      end
    end

    context "searching" do
      before do
        10.times  {|i| create(:channel, name: "channel#{i}") }
        @rock = create(:channel, name: "rock")
        @rock2 = create(:channel, name: "rockandroll")
      end

      it "returns rock channels" do
        get :index, format: :json, q: 'rock'
        channels = JSON.parse(response.body)
        expect(channels.size).to eq(2)
      end

      it "returns the first page" do
        get :index, format: :json, page: 1, per_page: 10
        channels = JSON.parse(response.body)
        expect(channels.size).to eq(10)
      end
    end

  end

  describe "GET #show" do
    context "unexisting channel" do

      before do
        get :show, id: "unknown_channel", format: :json
      end

      it "returns not found status code" do
        expect(response.status).to be(404)
      end

      it "returns an empty response" do
        expect(response.body).to be_blank
      end

    end

    context "With valid channels" do
      before do
        @new_channel = create(:channel, streams: [create(:stream)])
        get :show, id: @new_channel.name, format: :json
        @json_channel = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "returns correct json structure" do
        expect(@json_channel["name"]).to eq(@new_channel.name)
        expect(@json_channel["created_at"]).to eq(@new_channel.created_at.to_s(:api))
        expect(@json_channel["streams_count"]).to eq(@new_channel.streams.count)
        expect(@json_channel["streams"]).to have(1).items

        stream = @json_channel["streams"].first
        expect(stream["caption"]).not_to be_empty
        expect(stream["channels"]).not_to be_empty
      end

    end
  end

  describe "POST #create" do

    context "logged in" do

      login_user

      before do
        @post_hash = {format: :json, name: 'MyNewChannel123'}

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

    context "not logged" do

      before do
        post :create, name: "MyNewChannel123", format: 'json'
        @json_channel = JSON.parse(response.body)
      end

      it "returns access denied code" do
        expect(response.status).to be(401)
      end

      it "doesn't change the channel count" do
        expect{post :create, name: 'Testchannelcreation', format: :json}.not_to change(Channel, :count).by(1)
      end

      it "returns a new channel object" do
        expect(@json_channel["error"]).to include('need to sign')
      end
    end

  end

  describe "DELETE #destroy" do

    context "logged in" do

      login_user

      before do
        @delete_channel = create(:channel)
      end

      it "returns no content status" do
        delete :destroy, id: @delete_channel.id, format: :json
        expect(response.status).to be(204)
      end

      it "decreses the channel count" do
        expect{delete :destroy, id: @delete_channel.id, format: :json}.to change(Channel, :count).by(-1)
      end
    end


    context "not logged" do
      before do
        @delete_channel = create(:channel)
      end

      it "returns no content status" do
        delete :destroy, id: @delete_channel.id, format: :json
        expect(response.status).to be(401)
      end

      it "doesn't change the channel count" do
        expect{delete :destroy, id: @delete_channel.id, format: :json}.not_to change(Channel, :count)
      end
    end

  end


end
