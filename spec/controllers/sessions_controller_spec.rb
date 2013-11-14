require 'spec_helper'

describe Api::SessionsController do

  describe "POST #create" do

    before(:each) do
      @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
      #@user.confirm!
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end


    context "with valid credentials" do

      before(:each) do
        @post_hash = {email: @user.email, password: '12345678'}
        post :create, @post_hash
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(201)
      end

      it "returns valid credentials" do
        expect(@json_response["auth_token"]).not_to be("")
        expect(@json_response["user"]["id"]).to be_nil
        expect(@json_response["user"]["email"]).to eql(@user.email)
        expect(@json_response["user"]["name"]).to eql(@user.name)
      end
    end

    context "with invalid password" do

      before(:each) do
        @invalid_user = {email: @user.email, password: '1234567'}
        post :create, @invalid_user
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(401)
      end

      it "returns error message" do
        expect(@json_response["message"]).to include('Error')
      end
    end

    context "with invalid email" do

      before(:each) do
        @invalid_user = {email: "nobody@peepol.tv", password: '12345678'}
        post :create, @invalid_user
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(401)
      end

      it "returns error message" do
        expect(@json_response["message"]).to include('Error')
      end
    end

  end

  describe "GET #show" do

    context "not logged in" do

      before(:each) do
        @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
        @request.env["devise.mapping"] = Devise.mappings[:user]

        get :show
      end

      it "returns invalid credentials code" do
        expect(response.status).to be(401)
      end

      it "returns invalid credentials code" do
        expect(response.body).to eql("{}")
      end


    end

    context "logged in" do
      login_user
      before(:each) do
        get :show
        @json_response = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response.status).to be(200)
      end

      it "returns valid credentials" do
        expect(@json_response["auth_token"]).not_to be("")
        expect(@json_response["user"]["id"]).to be_nil
        expect(@json_response["user"]["email"]).to eql(@user.email)
        expect(@json_response["user"]["name"]).to eql(@user.name)
      end

    end

  end

  describe "DELETE #destroy" do

    context "not logged in" do

      before(:each) do
        @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
        @request.env["devise.mapping"] = Devise.mappings[:user]

        delete :destroy
        @json_response = JSON.parse(response.body)
      end

      it "returns invalid credentials code" do
        expect(response.status).to be(401)
      end

    end

    context "logged in" do

      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = FactoryGirl.create(:user, email: "test_user@platan.us", password: '12345678')
        user.confirmed_at = Time.now
        user.ensure_authentication_token!

        delete :destroy, auth_token: user.authentication_token
        @json_response = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response.status).to be(204)
      end

    end

  end

end
