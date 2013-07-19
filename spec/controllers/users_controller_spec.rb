require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    before do
      @user = create(:user)
      get :show, id: @user.id
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
      expect(@json_user).to have(3).items
    end

  end

end
