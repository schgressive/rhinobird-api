require 'spec_helper'

describe Api::StreamsPoolController do

  login_user

  describe "GET #index" do
    context "current user" do
      before do
        @stream = create(:stream)
        @offline = create(:stream, live: false)
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
        @stream = create(:stream, user: @given_user)
        @offline = create(:stream, live: false, user: @given_user)
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
        @stream_pool = create(:stream_pool, active: false, user: @user)
        put :update, format: :json, stream_id: @stream_pool.stream_id, active: true
        @json = JSON.parse(response.body)
      end

      it "changes the active flag" do
        expect(@json["active"]).to be_true
      end

      it "embeds the stream" do
        expect(@json["stream"]["id"]).to eq(@stream_pool.stream.to_param)
      end
    end

    context "offline stream" do
      before do
        offline = create(:stream, live: false)
        @stream_pool = create(:stream_pool, active: false, user: @user, stream: offline)
        put :update, format: :json, stream_id: @stream_pool.stream_id, active: true
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
      expect{delete :destroy, format: :json, stream_id: @inactive_stream.stream_id}.to change(@user.reload.stream_pools, :count).by(-1)
    end

    it "doesn't remove an active stream" do
      expect{delete :destroy, format: :json, stream_id: @active_stream.stream_id}.not_to change(@user.reload.stream_pools, :count)
    end

    it "removes the stream active stream from the pool if it's the only stream" do
      StreamPool.delete_all
      stream = create(:stream_pool, user: @user, active: true)
      expect{delete :destroy, format: :json, stream_id: stream.stream_id}.to change(StreamPool, :count).by(-1)
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
