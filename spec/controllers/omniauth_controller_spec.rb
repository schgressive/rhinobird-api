require 'spec_helper'

describe Api::OmniauthCallbacksController do
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
    uid: "100",
    info: {
      image: "#{ENV["HOST_PROTOCOL"]}://graph.facebook.com/100/picture?type=small",
      name: "Emilio Blanco"
    }
  })

  OmniAuth.config.add_mock(:facebook, {provider: "facebook", info: {email: "emilio@platan.us", nickname: "emilioeduardob"}})
  OmniAuth.config.add_mock(:google_oauth2, {provider: "google_oauth2", info: {email: "emilio@platan.us"}})
  OmniAuth.config.add_mock(:twitter, {provider: "twitter", info: {nickname: "emilioeduardob"}})


  describe "Facebook Auth" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    it "returns a redirect" do
      post :facebook
      expect(response).to redirect_to("#{ENV["HOST_PROTOCOL"]}://#{ENV['PUBLIC_HOST']}/profile/edit/?complete=facebook")
    end

    it "adds the user" do
      post :facebook
      user = User.last
      expect(user.name).to eq("Emilio Blanco")
      expect(user.username).to eq("emilioeduardob")
      expect(user.email).to eq("emilio@platan.us")
      expect(user.photo).to match(/picture/)
    end

    it "redirects to home screen" do
      post :facebook # register first time
      post :facebook

      expect(response).to redirect_to("#{ENV["HOST_PROTOCOL"]}://#{ENV['PUBLIC_HOST']}")
    end

    it "uses the existing user" do
      post :facebook

      # try to create google
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
      post :google_oauth2

      expect(response).to redirect_to("#{ENV["HOST_PROTOCOL"]}://#{ENV['PUBLIC_HOST']}")
    end
  end

  describe "Twitter Auth" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    it "returns a redirect" do
      post :twitter
      expect(response).to redirect_to("#{ENV["HOST_PROTOCOL"]}://#{ENV['PUBLIC_HOST']}/profile/edit/?complete=twitter")
    end

    it "adds the user" do
      post :twitter
      user = User.last
      expect(user.name).to eq("Emilio Blanco")
      expect(user.username).to eq("emilioeduardob")
      expect(user.photo).to match(/picture/)
      expect(user.email).to match(/emilioeduardob@twitter.com/)
    end
  end

  describe "Google Auth" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    it "returns a redirect" do
      post :google_oauth2
      expect(response).to redirect_to("#{ENV["HOST_PROTOCOL"]}://#{ENV['PUBLIC_HOST']}/profile/edit/?complete=google")
    end

    it "adds the user" do
      post :google_oauth2
      user = User.last
      expect(user.name).to eq("Emilio Blanco")
      expect(user.username).to eq("emilio@platan.us")
      expect(user.photo).to match(/picture/)
      expect(user.email).to match(/emilio@platan.us/)
    end
  end
end

