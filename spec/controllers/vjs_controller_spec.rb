require 'spec_helper'

describe Api::VjsController do

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
