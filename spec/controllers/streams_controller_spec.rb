require 'spec_helper'

describe Api::StreamsController do

  before do
    @stream = create(:live_stream)
  end

  describe "GET #index" do
    context "without a channel" do
      before do
        get :index, format: :json, force_check: true
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

    context "pagination and filters" do

      before do
        # @stream = defined on before
        10.times {create(:archived_stream)}
        @stream2 = create(:created_stream, caption: "stream 2", created_at: (Time.now + 10.seconds))
        @stream3 = create(:archived_stream, caption: "stream 3", created_at: (Time.now + 20.seconds))
        @stream4 = create(:archived_stream, caption: "stream 4", created_at: (Time.now + 30.seconds))
      end

      it "gets the first page of 12 results" do
        get :index, format: :json, page: 1
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(12)
      end

      it "skips :created status streams" do
        get :index, format: :json, page: 1, per_page: 100
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(13)
      end

      it "returns live streams" do
        get :index, format: :json, live: true
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(1)
        expect(streams[0]["caption"]).to eq(@stream.caption)
      end

      it "defins a custom page size" do
        get :index, format: :json, per_page: 2
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(2)
        expect(streams[0]["caption"]).to eq(@stream4.caption) # newst stream first
        expect(streams[1]["caption"]).to eq(@stream3.caption)
      end

      it "returns the pagination headers" do
        get :index, format: :json
        expect(response.headers["X-Page"]).to eq("1")
        expect(response.headers["X-Page-Total"]).to eq("2")
      end
    end

    context "search conditions" do

      before(:each) do
        @user = create(:user, username: "sirius")
        #@live_stream0 created before
        @stream1 = create(:archived_stream, caption: "live from #rock in rio")
        @stream2 = create(:archived_stream, caption: "riot on paris", user: @user)
        @stream3 = create(:archived_stream, caption: "voting for president", stream_id: 820533185964450300)
        @asuncion = create(:pending_stream, caption: "car #crash #live", lat: -25.320530, lng: -57.560549)
        @another = create(:archived_stream, caption: "bus crash", lat: -25.323168, lng: -57.555227)
        @live_stream = create(:live_stream, caption: "real time video")
      end

      context "filters status" do

        it "searches by live status" do
          get :index, format: :json, live: true
          streams = JSON.parse(response.body)
          expect(streams.size).to eq(2)
        end

        it "searchs by archived status" do
          get :index, format: :json, archived: true
          streams = JSON.parse(response.body)
          expect(streams.size).to eq(4)
        end

        it "searchs by live and archived status" do
          get :index, format: :json, live: true, archived: true
          streams = JSON.parse(response.body)
          expect(streams.size).to eq(6)
        end

      end

      context "by channels" do
        it "searches by similiar channel names" do
          get :related, format: :json, id: @asuncion.to_param
          streams = JSON.parse(response.body)
          expect(streams.size).to eq(2)
        end
      end

      it "returns the stream by keyword" do
        get :index, format: :json, q: 'LIVE'
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(2)
        expect(streams.first["caption"]).to match(/car/)
      end

      it "returns a stream by licode stream_id" do
        get :index, format: :json, stream_id: 820533185964450300
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(1)
        expect(streams.first["caption"]).to match(/president/)
      end

      it "returns the stream by channel" do
        get :index, format: :json, q: 'rock'
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(1)
        expect(streams.first["caption"]).to match(/rock/)
      end

      it "returns the stream by username" do
        get :index, format: :json, q: 'sirius'
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(1)
        expect(streams.first["caption"]).to match(/paris/)
      end

      it "returns the stream by geo reference" do
        get :index, format: :json, q: 'england'
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(7)
      end

      it "returns streams by lat and lng" do

        get :index, format: :json, lat: -25.316846, lng: -57.571632, range: 1 #km
        streams = JSON.parse(response.body)
        expect(streams.size).to eq(1)
        expect(streams.first["caption"]).to match(/crash/)

      end

    end

    context "with a channel" do
      before do
        create(:archived_stream)
        @channel = create(:channel, streams: [create(:archived_stream), create(:archived_stream)])
        get :index, channel_id: @channel.to_param, format: :json
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

    context "for a user" do
      before do
        @user = create(:user)
        @stream = create(:archived_stream, user: @user)
        @userb = create(:user, streams: [create(:archived_stream), create(:archived_stream)])

        get :index, user_id: @user.to_param, format: :json
        @streams = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "returns the streams for the user" do
        expect(@streams).to have(1).items
        expect(@streams.first["id"]).to eq(@stream.to_param)
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
          @stream = create(:stream, status: 0)
          put :update, id: @stream.id, stream_id: "123", caption: 'rock', format: :json
        end

        it "returns the success code" do
          expect(response.status).to eql(200)
        end

        it "returns the updated stream" do
          stream = JSON.parse(response.body)
          expect(stream["id"]).to eql(@stream.to_param)
          expect(stream["caption"]).to eql("rock")
          expect(stream["status"]).to eql("live")
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

  describe "PUT #play" do

    context "existing stream" do
      before(:each) do
        @stream = create(:stream, playcount: 1)
        put :play, format: :json, id: @stream.id
      end

      it "increments the playcount of the stream" do
        @stream.reload
        expect(@stream.playcount).to eq(2)
      end

      it "returns success status code" do
        expect(response).to be_success
      end
    end

    context "non existing stream" do
      it "returns 404 status code" do
        put :play, id: "1231312n", format: :json
        expect(response).to be_not_found
      end
    end


  end

  describe "PUT #update archived_url" do
      before(:each) do
        @stream = create(:stream)
        @api_user = create(:user)
        @api_user.ensure_authentication_token!
        put :update, id: @stream.id, archived_url: "http://url", format: :json, auth_token: @api_user.authentication_token
        @json_stream = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "changes the status to archived" do
        expect(@json_stream["status"]).to eql("archived")
        expect(@json_stream["archived_url"]).to eql("http://url")
      end
  end

  describe "POST #create" do

    context "with a channel" do
      login_user

      before(:each) do
        @channel = create(:channel, name: "concerts")
        mock_graph :post, 'me/feed', 'users/feed/post_with_valid_access_token' do
          post :create, format: :json, caption: "Best #rock #concerts ever"
        end
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
        mock_graph :post, 'me/feed', 'users/feed/post_with_valid_access_token' do
          post :create, format: :json, tags: "rock, grunge"
        end
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
        @post_hash = {caption: 'live from woodstock',
                      lat: -25.272062301637, lng: -57.585376739502,
                      format: :json}

        mock_graph :post, 'me/feed', 'users/feed/post_with_valid_access_token' do
          post :create, @post_hash
        end
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
        File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
          @image_base64 = "data:image/jpg;base64,#{file.read}"
        end

        post_hash = {caption: 'live from woodstock',
                      lat: -25.272062301637, lng: -57.585376739502,
                      thumb: @image_base64,
                      format: :json}

        post :create, post_hash
        json = JSON.parse(response.body)
        expect(json["thumbs"]["small"]).to match(/^http:\/\/.*small.jpg/)
        expect(json["thumbs"]["medium"]).to match(/^http:\/\/.*medium.jpg/)
        expect(json["thumbs"]["large"]).to match(/^http:\/\/.*large.jpg/)
      end

      it "returns the status" do
        expect(@json_stream["status"]).to eql("created")
        expect(@json_stream["stream_id"]).to be_nil
      end


      it "has a valid geoJSON format" do
        expect(@json_stream["type"]).to eq("Feature")
        expect(@json_stream["geometry"]["type"]).to eq("Point")
        expect(@json_stream["geometry"]["coordinates"]).to eq([@post_hash[:lng], @post_hash[:lat]])
        expect(@json_stream["properties"]["country"]).to eq("England")
        expect(@json_stream["properties"]["address"]).to eq("45 Main Street, Long Road")
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
      @channel = create(:channel)
      @new_stream = create(:stream, lat: -25.272062301637, lng: -57.585376739502, caption: "live for #developers")
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
      expect(@json_stream["channels"].size).to eq(1)
    end

    it "returns the attachment" do
      File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
        @image_base64 = "data:image/jpg;base64,#{file.read}"
      end

      stream = create(:stream, lat: -25.272062301637, lng: -57.585376739502, caption: "live for #developers", thumb: @image_base64)
      get :show, id: stream.id, format: :json
      json= JSON.parse(response.body)
      expect(json["thumbs"]["small"]).to match(/^http:\/\/.*small.jpg/)
      expect(json["thumbs"]["medium"]).to match(/^http:\/\/.*medium.jpg/)
      expect(json["thumbs"]["large"]).to match(/^http:\/\/.*large.jpg/)
    end

    it "returns the status" do
      expect(@json_stream["status"]).to eql("created")
    end

    it "has a valid geoJSON format" do
      expect(@json_stream["type"]).to eq("Feature")
      expect(@json_stream["geometry"]["type"]).to eq("Point")
      expect(@json_stream["geometry"]["coordinates"]).to eq([@new_stream.lng.to_f, @new_stream.lat.to_f])
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
