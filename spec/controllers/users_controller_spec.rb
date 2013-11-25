require 'spec_helper'

describe Api::UsersController do

  describe "GET #show" do

    context "not as VJ" do
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
        expect(@json_user["vj"]).to eq(false)
        expect(@json_user["username"]).to eq(@user.username)
        expect(@json_user["stream_pools"]).to be_empty
      end
    end

    context "as a VJ" do
      before do
        @user = create(:user)
        @stream = create(:stream_pool, user: @user)
        get :show, id: @user.to_param, format: :json
        @json_user = JSON.parse(response.body)
      end

      it "returns correct json structure" do
        expect(@json_user["name"]).to eq(@user.name)
        expect(@json_user["username"]).to eq(@user.username)
        expect(@json_user["email"]).to eq(@user.email)
        expect(@json_user["vj"]).to eq(true)
      end

      it "embeds the stream_pool" do
        pool = @json_user["stream_pools"]
        expect(pool[0]["stream"]["id"]).to eq(@stream.stream.to_param)
        expect(pool[0]["active"]).to be_false
      end
    end

  end

  describe "POST #create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    context "with new user information" do
      before(:each) do
        @user_info = {email: "sirius@peepol.tv", password: '12345678', name: "Sirius Black", username: 'sirius'}
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
          expect(mail).to deliver_to("sirius@peepol.tv")
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
        create(:user, email: "sirius@peepol.tv", name: "Sirius Black")
        @user_info = {email: "sirius@peepol.tv", password: '12345678', name: "Sirius Black"}
        post :create, @user_info
        @json_response = JSON.parse(response.body)
      end

      it "returns success code" do
        expect(response.status).to be(422)
      end

      it "returns user info" do
        expect(@json_response["email"][0]).to include("taken")
      end
    end

  end


end
