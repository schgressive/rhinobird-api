require 'spec_helper'

describe Api::RepostsController do
  login_user

  describe "POST #create" do

    it "reposts a vj" do
      vj = create(:vj)
      post :create, format: :json, vj_id: vj.to_param

      new_vj = Vj.last
      expect(Vj.count).to eq 2
      expect(new_vj.source_id).to eq vj.id
      expect(new_vj.user_id).to eq @user.id
      expect(new_vj.channel_id).to eq vj.channel_id
    end

    it "reposts a stream" do
      stream = create(:stream, caption: "Original stream")
      post :create, format: :json, stream_id: stream.to_param

      new_stream = Stream.last
      expect(Stream.count).to eq 2
      expect(new_stream.source_id).to eq stream.id
      expect(new_stream.user_id).to eq @user.id
      expect(new_stream.caption).to eq stream.caption
    end

  end
end
