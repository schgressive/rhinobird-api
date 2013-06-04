require 'spec_helper'

describe SessionsController do

  describe "POST #create" do

    before(:each) do
      @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
      @user.confirm!
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
        expect(@json_response["email"]).to eql(@user.email)
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

  describe "DELETE #destroy" do

    context "with valid email" do

      before(:each) do
        @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
        @user.confirm!
        @request.env["devise.mapping"] = Devise.mappings[:user]

        delete :destroy, email: @user.email
        @json_response = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response.status).to be(202)
      end

    end

    context "with unknown email" do

      before(:each) do
        @user = create(:user, email: 'sirius@peepol.tv', password: '12345678')
        @user.confirm!
        @request.env["devise.mapping"] = Devise.mappings[:user]

        delete :destroy, email: "nobody@peepol.tv"
        @json_response = JSON.parse(response.body)
      end

      it "returns a success code" do
        expect(response.status).to be(401)
      end

    end




  end

end
