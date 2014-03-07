require 'spec_helper'

describe Api::StreamsPoolController do

  login_user

  describe "GET #index" do
    context "current user" do
      before do
        @stream = create(:live_stream)
        @offline = create(:archived_stream)
        @stream_pool_offline = create(:stream_pool, user: @user, stream: @offline)
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

    context "for a given user" do
      before do
        @given_user = create(:user)
        @stream = create(:live_stream, user: @given_user)
        @offline = create(:archived_stream, user: @given_user)
        @stream_pool_offline = create(:stream_pool, user: @given_user, stream: @offline)
        @stream_pool = create(:stream_pool, user: @given_user, stream: @stream)

        get :index, user_id: @given_user.to_param, format: :json
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
  end

  describe "PUT #update" do
    context "live stream" do
      before do
        @stream_pool = create(:stream_pool, active: false, user: @user, stream: create(:live_stream), connected: false)
        put :update, format: :json, id: @stream_pool.stream.to_param, active: true, connected: true
        @json = JSON.parse(response.body)
      end

      it "changes the active flag" do
        expect(@json["active"]).to be_true
      end

      it "changes the connected flag" do
        expect(@json["connected"]).to be_true
      end

      it "embeds the stream" do
        expect(@json["stream"]["id"]).to eq(@stream_pool.stream.to_param)
      end
    end

    context "active audio" do

      before do
        @on_different = create(:stream_pool, audio_active: true)
        @on_stream = create(:stream_pool, audio_active: true, user: @user, stream: create(:live_stream))
        @muted_stream = create(:stream_pool, active: false, user: @user, stream: create(:live_stream))
        put :update, format: :json, id: @muted_stream.stream.to_param, audio_active: true
        @json = JSON.parse(response.body)
      end

      it "changes the active flag" do
        expect(@json["audio_active"]).to be_true
      end

      it "inactivate other audios" do
        @on_stream.reload
        expect(@on_stream.audio_active).to be_false
      end

      it "doesn't deactivate other users live audio" do
        @on_different.reload
        expect(@on_different.audio_active).to be_true
      end
    end

    context "offline stream" do
      before do
        offline = create(:archived_stream)
        @stream_pool = create(:stream_pool, active: false, user: @user, stream: offline)
        put :update, format: :json, id: @stream_pool.stream.to_param, active: true
        @json = JSON.parse(response.body)
      end

      it "returns status 409 Conflict" do
        expect(response.status).to eq(409)
      end
      it "returns an error" do
        expect(@json["error"]).to eq("Can't activate offline stream")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @inactive_stream = create(:stream_pool, user: @user, active: false)
      @active_stream = create(:stream_pool, user: @user, active: true)
    end

    it "removes the stream from the pool" do
      expect{delete :destroy, format: :json, id: @inactive_stream.stream.to_param}.to change(@user.reload.stream_pools, :count).by(-1)
    end

    it "doesn't remove an active stream" do
      expect{delete :destroy, format: :json, id: @active_stream.stream.to_param}.not_to change(@user.reload.stream_pools, :count)
    end

    it "removes the stream active stream from the pool if it's the only stream" do
      StreamPool.delete_all
      stream = create(:stream_pool, user: @user, active: true)
      expect{delete :destroy, format: :json, id: stream.stream.to_param}.to change(StreamPool, :count).by(-1)
    end


  end

  describe "POST #create" do

    before do
      @stream = create(:stream, caption: "hello #test")
      @stream1 = create(:stream, caption: "bye #test")
      @stream2 = create(:stream, caption: "hello #nothing")
      post :create, format: :json, stream_id: @stream.id, channel_name: "test", active: true

      @json= JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "sets the user's VJ channel name" do
      @user.reload
      expect(@user.vj_channel_name).to eq("test")
    end

    it "empties the pool if a different channel is set" do
      post :create, format: :json, stream_id: @stream1.id, channel_name: "test", active: true
      post :create, format: :json, stream_id: @stream2.id, channel_name: "nothing", active: true
      expect(@user.stream_pools.count).to eq(1)
    end

    it "ignores the same stream" do
      post :create, format: :json, stream_id: @stream.id, active: true
      expect(@user.stream_pools.count).to eq(1)
    end

    it "increments the stream pool count" do
      stream = create(:stream)
      expect{post :create, format: :json, stream_id: stream.id}.to change(StreamPool, :count).by(1)
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
