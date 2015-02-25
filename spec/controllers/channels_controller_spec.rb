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
        expect(@channels.size).to eq(1)
        expect(@channels[0]["name"]).to eq(@channel.name)
      end
    end

    context "searching" do
      before do
        10.times  {|i| create(:channel, name: "channel#{i}") }
        @rock = create(:channel, name: "rock")
        @rock2 = create(:channel, name: "rockandroll")

        @asuncion = create(:stream, lat: -25.307737, lng: -57.592392, caption: "#rock from the world")
        @asuncion2 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#rock from disney')
        @asuncion3 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#live from #marvel')
        @asuncion4 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#marvel from disney')
        @asuncion5 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#donald from disney')
        @asuncion6 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#marvel from disney')
        Timecop.freeze(Time.now + 5.seconds) do
          @asuncion7 = create(:stream, lat: -25.3263, lng: -57.6102, caption: '#roller from disney')
        end
        @chile = create(:stream, lat: -33.3981121, lng: -70.5808448, caption: '#rockandroll party')
      end

      it "returns rock channels" do
        get :index, format: :json, q: 'rock'
        channels = JSON.parse(response.body)
        expect(channels.size).to eq(2)
      end

      it "returns channels near a location" do
        get :index, format: :json, lat: -25.31, lng: -57.60
        channels = JSON.parse(response.body)
        expect(channels.size).to eq(5)
        # Most popular
        expect(channels[0]["name"]).to match(/marvel/)
        # Newest
        expect(channels[1]["name"]).to match(/roller/)
        # Second Most popular
        expect(channels[2]["name"]).to match(/rock/)
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
        expect{post :create, name: 'Testchannelcreation', format: :json}.not_to change(Channel, :count)
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
