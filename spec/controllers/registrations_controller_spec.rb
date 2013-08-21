require 'spec_helper'

describe Api::RegistrationsController do

  describe "POST #create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "with new user information" do
      before(:each) do
        @user_info = {user: {email: "sirius@peepol.tv", password: '12345678', name: "Sirius Black", username: 'sirius'}}
        post :create, @user_info, format: :json
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(200)
      end

      it "returns user info" do
        expect(@json_response["success"]).to be_true
        expect(@json_response["info"]).to eql("Registered")
        expect(@json_response["data"]["user"]["email"]).to eql(@user_info[:user][:email])
        expect(@json_response["data"]["user"]["name"]).to eql(@user_info[:user][:name])
        expect(@json_response["data"]["user"]["id"]).to eq(@user_info[:user][:username])
        expect(@json_response["data"]["user"]["username"]).to eq(@user_info[:user][:username])
      end
    end

    context "with duplicated user information" do
      before(:each) do
        create(:user, email: "sirius@peepol.tv", name: "Sirius Black")
        @user_info = {user: {email: "sirius@peepol.tv", password: '12345678', name: "Sirius Black"}}
        post :create, @user_info
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(422)
      end

      it "returns user info" do
        expect(@json_response["success"]).to be_false
        expect(@json_response["info"]["email"][0]).to include("taken")
      end
    end

  end


end
