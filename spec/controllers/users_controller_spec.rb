require 'spec_helper'

describe Api::UsersController do

  describe "GET #index" do
    before do
      1.times {|i| create(:user) }
      create(:user, name: "Sherlock Holmes", username: "emilio")
    end

    it "returns the searched users name" do
      get :index, format: :json, q: 'sherlock'
      users = JSON.parse(response.body)
      expect(users.size).to eq(1)
    end

    it "returns the searched users username" do
      get :index, format: :json, q: 'emilio'
      users = JSON.parse(response.body)
      expect(users.size).to eq(1)
    end

  end

  describe "GET #show" do

    before do
      @user = create(:user)
      get :show, id: @user.to_param, format: :json
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
      expect(@json_user["username"]).to eq(@user.username)
      expect(@json_user["facebook_connected"]).to eq(@user.valid_fb_token?)
      expect(@json_user["twitter_connected"]).to eq(@user.valid_tw_token?)
    end

  end

  describe "POST #create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "with new user information" do
      before(:each) do
        @user_info = {email: "sirius@rhinobird.tv", password: '12345678', name: "Sirius Black", username: 'sirius'}
        post :create, @user_info, format: :json
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to eq(201)
      end

      it "returns user info" do
        expect(@json_response["success"]).to be_nil
        expect(@json_response["info"]).to be_nil
        expect(@json_response["id"]).to be_nil

        expect(@json_response["email"]).to eql(@user_info[:email])
        expect(@json_response["name"]).to eql(@user_info[:name])
        expect(@json_response["username"]).to eq(@user_info[:username])
      end

      context "confirmation email" do
        subject(:mail) { ActionMailer::Base.deliveries.last}

        it "sends to the user email" do
          expect(mail).to deliver_to("sirius@rhinobird.tv")
        end
        it "has a the correct subject" do
          expect(mail).to have_subject(/Confirmation/)
        end
        it "sends from the default sender" do
          expect(mail).to deliver_from(ENV["DEFAULT_SENDER"])
        end
        it "includes the confirmation link" do
          expect(mail).to have_body_text(/#{user_confirmation_path}/)
        end
      end
    end

    context "with duplicated user information" do
      before(:each) do
        create(:user, email: "sirius@rhinobird.tv", name: "Sirius Black", username: "sirius")
        @user_info = {email: "sirius@rhinobird.tv", password: '12345678', name: "Sirius Black", username: "sirius"}
        post :create, @user_info
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(422)
      end

      it "returns user info" do
        expect(@json_response["email"][0]).to include("taken")
        expect(@json_response["username"][0]).to include("taken")
      end
    end

  end


  describe "PUT #update" do

    login_user

    before(:each) do
      @hash = {email: "newemail@rhinobird.tv", username: "donaldduck", share_facebook: false, custom_tweet: "Tweet this!", enable_custom_tweet: true}
      put :update, @hash
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "updates the user information" do
      @user.reload
      expect(@user.email).to eq(@hash[:email])
      expect(@user.username).to eq(@hash[:username])
      expect(@user.custom_tweet).to eq(@hash[:custom_tweet])
      expect(@user.share_facebook).to be_false
    end

    it "returns the updated JSON object" do
      json = JSON.parse(response.body)
      expect(json["email"]).to eq(@hash[:email])
      expect(json["username"]).to eq(@hash[:username])
      expect(json["custom_tweet"]).to eq(@hash[:custom_tweet])
      expect(json["share_facebook"]).to be_false
      expect(json["enable_custom_tweet"]).to be_true
    end

  end


end
