require 'spec_helper'

describe Api::PicksController do

  describe "POST #create" do
    login_user

    before do
      @vj = create(:vj, user: @user)
      @stream = create(:stream, thumbnail: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/images/rails.png'), 'image/png'))
      @object = {stream_id: @stream.to_param}

      post :create, format: :json, vj_id: @vj.to_param, stream_id: @stream.to_param, active: "true"
      @json = JSON.parse(response.body)
    end

    it "returns a success code" do
      expect(response.status).to eq 201
    end

    it "returns the new JSON Vj object" do
      expect(@json["active"]).to eq(true)
      expect(@json["active_audio"]).to eq(false)
      expect(@json["stream"]["id"]).to eq(@stream.to_param)
    end

    it "updates the VJ thumbnail" do
      @vj.reload
      stream = Stream.find(@json["stream"]["id"])
      expect(@vj.thumbnail_file_name).to eq(stream.thumbnail_file_name)
      expect(@vj.thumbnail_file_size).to eq(stream.thumbnail_file_size)
    end

  end #describe POST create

  describe "DELETE #destroy" do
    login_user

    before do
      @my_pick = create(:pick, vj: create(:vj, user: @user))
      @other_pick = create(:pick)
    end

    it "remove my pick" do
      delete :destroy, format: :json, id: @my_pick.to_param
      expect(response.status).to eq 204
    end

    it "can't remove another users pick" do
      delete :destroy, format: :json, id: @other_pick.to_param
      expect(response.status).to eq 401
    end

  end #describe POST create

  describe "PUT #update" do
    login_user

    before do
      @my_pick = create(:pick, vj: create(:vj, user: @user))
      @other_pick = create(:pick)
    end

    it "update my pick" do
      put :update, format: :json, id: @my_pick.to_param, active: true, stream_id: @my_pick.stream.to_param
      expect(response.status).to eq 200
      json = JSON.parse(response.body)
      expect(json["active"]).to eq(true)
    end

    it "can't update another users pick" do
      put :update, format: :json, id: @other_pick.to_param, active: true
      expect(response.status).to eq 401
    end

  end #describe PUT update

end
