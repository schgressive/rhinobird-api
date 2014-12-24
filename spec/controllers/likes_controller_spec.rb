require 'spec_helper'

describe Api::LikesController do

  login_user

  describe "POST #create" do
    it "likes a stream" do
      stream = create(:stream)
      post :create, format: :json, stream_id: stream.to_param
      expect(response.status).to eq 204
      expect(Like.last.likeable_id).to eq stream.id
    end

    it "returns 404 to unknown resource" do
      post :create, format: :json, stream_id: "ABC"
      expect(response.status).to eq 404
    end
  end

  describe "DELETE #destroy" do
    it "dislikes a stream" do
      stream = create(:stream)
      like = create(:like, likeable: stream, user: @user)
      delete :destroy, format: :json, stream_id: stream.to_param
      expect(response.status).to eq 204
      expect(Like.last).to be_nil
    end

    it "returns 404 to unknown resource" do
      delete :destroy, format: :json, stream_id: "ABC"
      expect(response.status).to eq 404
    end
  end
end
