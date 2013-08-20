require 'spec_helper'

describe Api::UsersController do

  describe "GET #show" do

    context "not as VJ" do
      before do
        @user = create(:user)
        get :show, id: @user.id, format: :json
        @json_user = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns correct content type" do
        expect(response.header['Content-Type']).to include("application/json")
      end

      it "returns correct json structure" do
        expect(@json_user["id"]).to eq(@user.id)
        expect(@json_user["name"]).to eq(@user.name)
        expect(@json_user["email"]).to eq(@user.email)
        expect(@json_user["vj"]).to eq(false)
        expect(@json_user).to have(4).items
      end
    end

    context "as a VJ" do
      before do
        @user = create(:user)
        stream = create(:stream_pool, user: @user)
        get :show, id: @user.id, format: :json
        @json_user = JSON.parse(response.body)
      end

      it "returns correct json structure" do
        expect(@json_user["id"]).to eq(@user.id)
        expect(@json_user["name"]).to eq(@user.name)
        expect(@json_user["email"]).to eq(@user.email)
        expect(@json_user["vj"]).to eq(true)
      end
    end

  end

end
