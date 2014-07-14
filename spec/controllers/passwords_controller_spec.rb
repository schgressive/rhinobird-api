require 'spec_helper'

describe Api::PasswordsController do

  describe "POST #create" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      post :create, email: @user.email, format: :json
    end

    it "returns success code" do
      expect(response).to be_success
    end

    it "sends email instructions" do
      last_email = ActionMailer::Base.deliveries.last

      expect(last_email.to).to include(@user.email)
      expect(last_email.subject).to match(/password/)
    end

  end

  describe "PUT #update" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      token = @user.send_reset_password_instructions
      @user.reload

      put :update, token: token, password: "adminadmin", password_confirmation: "adminadmin", format: :json
    end

    it "returns success code" do
      expect(response).to be_success
    end

    it "changes the password" do
      @user.reload
      expect(@user.valid_password?("adminadmin")).to be_true
    end

  end
end

