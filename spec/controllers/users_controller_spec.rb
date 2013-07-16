require 'spec_helper'

describe UsersController do

  describe "GET #show" do
    before do
      @user = create(:user)
      get :show, id: @user.to_param
      @json_user = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns correct json structure" do
      expect(@json_user["name"]).to eq(@user.name)
      expect(@json_user["email"]).to eq(@user.email)
    end

  end

end
