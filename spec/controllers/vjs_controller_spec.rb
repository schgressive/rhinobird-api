require 'spec_helper'

describe Api::VjsController do

  describe "GET #index" do

    context "filtering" do
      before do
        @live_vj = create(:vj, status: :live)
        @pending_vj = create(:vj, status: :pending, channel: create(:channel, name: "funland"))
      end

      it "filters by channel_name" do
        get :index, format: :json, channel_name: 'funland'
        @json = JSON.parse(response.body)

        expect(@json.length).to eq(1)
        expect(@json[0]["id"]).to eq(@pending_vj.to_param)
      end

      it "filters by status" do
        get :index, format: :json, status: 'live'
        @json = JSON.parse(response.body)

        expect(@json.length).to eq(1)
        expect(@json[0]["id"]).to eq(@live_vj.to_param)
      end
    end

    context "without params" do
      before do
        @vj = create(:vj)
        get :index, format: :json
        @json = JSON.parse(response.body).first
      end

      it "returns a success code" do
        expect(response).to be_success
      end

      it "returns correct json structure" do
        expect(@json["id"]).to eq(@vj.to_param)
        expect(@json["username"]).to eq(@vj.user.username)
        expect(@json["channel_name"]).to eq(@vj.channel.name)
        expect(@json["status"]).to eq("created")
        expect(@json["archived_url"]).to eq(@vj.archived_url)
      end
    end

  end #describe GET SHOW


  describe "GET #show" do

    before do
      @vj = create(:vj)
      get :show, id: @vj.to_param, format: :json
      @json = JSON.parse(response.body)
    end

    it "returns a success code" do
      expect(response).to be_success
    end

    it "returns correct json structure" do
      expect(@json["id"]).to eq(@vj.to_param)
      expect(@json["username"]).to eq(@vj.user.username)
      expect(@json["channel_name"]).to eq(@vj.channel.name)
      expect(@json["status"]).to eq("created")
      expect(@json["archived_url"]).to eq(@vj.archived_url)
    end

  end #describe GET SHOW


  describe "POST #create" do
    login_user

    before do
      @channel = create(:channel, name: "rock")
      post :create, format: :json, channel_name: "rock"
      @json = JSON.parse(response.body)
    end

    it "returns a success code" do
      expect(response.status).to eq 201
    end

    it "returns the new JSON Vj object" do
      expect(@json["status"]).to eq("created")
      expect(@json["channel_name"]).to eq("rock")
      expect(@json["username"]).to eq(@user.username)
    end

  end #describe POST create

  describe "PUT #update" do
    login_user

    context "Own vj" do
      before do
        @vj = create(:vj, user: @user)
        put :update, id: @vj.to_param, format: :json, status: "archived", archived_url: "s3_path"
        @json = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response).to be_success
      end

      it "updates the vj" do
        expect(@json["id"]).to eq(@vj.to_param)
        expect(@json["status"]).to eq("archived")
        expect(@json["archived_url"]).to eq("s3_path")
      end
    end

    context "Another user's vj" do
      before do
        @vj = create(:vj)
        put :update, id: @vj.to_param, format: :json, status: "archived", archived_url: "s3_path"
        @json = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response).not_to be_success
      end
    end

  end #describe PUT update
end
