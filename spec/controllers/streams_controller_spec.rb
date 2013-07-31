require 'spec_helper'

describe Api::StreamsController do

  before do
    @stream = create(:stream)
  end

  describe "GET #index" do
    context "without a channel" do
      before do
        get :index, format: :json
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
        expect(@streams[0]["caption"]).to eq(@stream.caption)
      end
    end

    context "with a channel" do
      before do
        create(:stream)
        @channel = create(:channel, streams: [create(:stream), create(:stream)])
        get :index, channel_id: @channel.id, format: :json
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

  describe "PUT #update" do

    context "logged in" do

      login_user

      context "add a stream to a channel" do

        before(:each) do
          @channel = create(:channel, name: "riot")
          @stream = create(:stream)
          @params = {caption: "#riot in egypt", id: @stream.id, format: :json}
        end

        it "assigns the channel to the stream" do
          expect{put :update, @params}.to change{@channel.streams.count}.by(1)
        end

        it "returns the added stream" do
          put :update, @params
          stream = JSON.parse(response.body)
          expect(stream["id"]).to eql(@stream.to_param)
          expect(stream["channels"].first["id"]).to eql(@channel.to_param)
        end
      end

      context "update a stream" do

        before(:each) do
          @stream = create(:stream, live: false)
          put :update, id: @stream.id, live: true, caption: 'rock', format: :json
        end

        it "returns the success code" do
          expect(response.status).to eql(200)
        end

        it "returns the updated stream" do
          stream = JSON.parse(response.body)
          expect(stream["id"]).to eql(@stream.to_param)
          expect(stream["caption"]).to eql("rock")
          expect(stream["live"]).to be_true
        end
      end

    end

    context "not logged in" do

      before(:each) do
        @channel = create(:channel)
        @stream = create(:stream)
      end

      it "assigns the channel to the stream" do
        expect{put :update, channel_id: @channel.id, id: @stream.id, format: :json}.not_to change{@channel.streams.count}.by(1)
      end

      it "returns access denied response" do
        put :update, channel_id: @channel.id, id: @stream.id, format: :json
        expect(response.status).to be(401)
      end

    end

  end

  describe "POST #create" do

    context "with a channel" do
      login_user

      before(:each) do
        @channel = create(:channel, name: "concerts")
        post :create, format: :json, caption: "Best #rock #concerts ever"
        @json_stream = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(201)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "adds the channels" do
        expect(@json_stream["channels"].size).to eql(2)
      end

    end

    context "with tags" do
      login_user

      before(:each) do
        post :create, format: :json, tags: "rock, grunge"
        @json_stream = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(201)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "returns the stream with the tags" do
        expect(@json_stream["tags"]).to have(2).items
      end

    end

    context "logged in" do

      login_user

      before(:each) do
        File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
          @image_base64 = "data:image/jpg;base64,#{file.read}"
        end

        @post_hash = {caption: 'live from woodstock',
                      lat: -25.272062301637, lng: -57.585376739502,
                      geo_reference: 'Unkown location',
                      thumb: @image_base64,
                      live: true,
                      format: :json}

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
        expect(@json_stream["caption"]).to eq(@post_hash[:caption])
        expect(@json_stream["id"]).not_to be("")
        expect(@json_stream["channels"]).to be_empty
      end

      it "returns a thumb information" do
        expect(@json_stream["thumbs"]["small"]).to match(/^http:\/\/.*small.jpg/)
        expect(@json_stream["thumbs"]["medium"]).to match(/^http:\/\/.*medium.jpg/)
        expect(@json_stream["thumbs"]["large"]).to match(/^http:\/\/.*large.jpg/)
      end

      it "returns the live token" do
        expect(@json_stream["live"]).to be_true
      end


      it "has a valid geoJSON format" do
        expect(@json_stream["type"]).to eq("Feature")
        expect(@json_stream["geometry"]["type"]).to eq("Point")
        expect(@json_stream["geometry"]["coordinates"]).to eq([@post_hash[:lng], @post_hash[:lat]])
        expect(@json_stream["properties"]["geo_reference"]).to eq(@post_hash[:geo_reference])
      end

      it "has user information" do
        expect(@json_stream["user"]["name"]).to eq(@user.name)
        expect(@json_stream["user"]["email"]).to eq(@user.email)
      end

    end

    context "not logged" do

      before(:each) do
        post :create, caption: "hello", format: :json
      end

      it "returns access denied" do
        expect(response.status).to be(401)
      end

      it "returns an empty response" do
        json = JSON.parse(response.body)
        expect(json["error"]).to include('need to sign')
      end


    end
  end

  context "GET #show" do
    before do
      File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
        @image_base64 = "data:image/jpg;base64,#{file.read}"
      end

      @channel = create(:channel)
      @new_stream = create(:stream, lat: -25.272062301637, lng: -57.585376739502, caption: "live for #developers", thumb: @image_base64)
      get :show, id: @new_stream.id, format: :json
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
      expect(@json_stream["caption"]).to eq(@new_stream.caption)
      expect(@json_stream["started_on"]).to eq(@new_stream.started_on.to_s(:api))
      expect(@json_stream["thumbs"]["small"]).to match(/^http:\/\/.*small.jpg/)
      expect(@json_stream["thumbs"]["medium"]).to match(/^http:\/\/.*medium.jpg/)
      expect(@json_stream["thumbs"]["large"]).to match(/^http:\/\/.*large.jpg/)
      expect(@json_stream["channels"].size).to eq(1)
    end

    it "returns the live token" do
      expect(@json_stream["live"]).to be_false
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([@new_stream.lng.to_f, @new_stream.lat.to_f])
      expect(@json_stream["properties"]["geo_reference"]).to eq(@new_stream.geo_reference)
    end

    it "has user information" do
      user = @new_stream.user
      expect(@json_stream["user"]["name"]).to eq(user.name)
      expect(@json_stream["user"]["email"]).to eq(user.email)
    end

  end

  context "DELETE #destroy" do

    login_user

    before do
      @delete_stream = create(:stream)
      @params = {id: @delete_stream.id, format: :json}
    end

    it "returns no content status" do
      delete :destroy, @params
      expect(response.status).to be(204)
    end

    it "decreses the stream count" do
      expect{delete :destroy, @params}.to change(Stream, :count).by(-1)
    end

  end


end
