require 'spec_helper'

describe Api::VjsController do
  describe "GET #show" do

    before do
      @vj = create(:vj)
      get :show, id: @vj.to_param, format: :json
      @json = JSON.parse(response.body)
    end

    it "returns a success code" do
      expect(response).to be_success
    end

    it "returns correct json structure" do
      expect(@json["id"]).to eq(@vj.to_param)
      expect(@json["username"]).to eq(@vj.user.username)
      expect(@json["channel_name"]).to eq(@vj.channel.name)
      expect(@json["status"]).to eq("created")
      expect(@json["archived_url"]).to eq(@vj.archived_url)
    end

  end

end
