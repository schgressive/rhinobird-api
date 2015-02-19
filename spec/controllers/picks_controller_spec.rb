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
      expect(@json["fixed_audio"]).to eq(false)
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

    context "updates attributes" do
      before do
        @my_pick = create(:pick, vj: create(:vj, user: @user))
        @other_pick = create(:pick)
      end

      it "update my pick" do
        put :update, format: :json, id: @my_pick.to_param, active: true, stream_id: @my_pick.stream.to_param
        expect(response.status).to eq 200
        json = JSON.parse(response.body)
        expect(json["active"]).to eq(true)
        expect(json["fixed_audio"]).to eq(false)
      end

      it "can't update another users pick" do
        put :update, format: :json, id: @other_pick.to_param, active: true
        expect(response.status).to eq 401
      end
    end

    context "events" do

      let(:vj) { create(:vj, user: @user, status: "live") }

      it "generates audio and video events" do
        active_pick = create(:pick, vj: vj, active: true, fixed_audio: true)
        other_pick = create(:pick, vj: vj, active: false, fixed_audio: false)
        put :update, format: :json, id: other_pick.to_param, fixed_audio: true, active: true

        expect(Event.count).to eq 2

        audio = vj.fetch_last_event(:audio)
        video = vj.fetch_last_event(:video)

        expect(audio.stream_id).to eq other_pick.stream_id
        expect(audio.track_type).to eq "audio"

        expect(video.stream_id).to eq other_pick.stream_id
        expect(video.track_type).to eq "video"


      end

    end

    context "related picks" do

      let(:vj) { create(:vj, user: @user) }

      it "actives the audio of the active video pick" do
        video_pick = create(:pick, vj: vj, active: true, fixed_audio: false)
        audio_pick = create(:pick, vj: vj, active: false, fixed_audio: true)
        put :update, format: :json, id: audio_pick.to_param, fixed_audio: false

        audio_pick.reload
        video_pick.reload

        expect(audio_pick.active).to be_falsey
        expect(audio_pick.fixed_audio).to be_falsey

        expect(video_pick.active).to be_truthy
        expect(video_pick.fixed_audio).to be_truthy

      end

      it "inactivates another picks when activating a new one" do
        video_pick = create(:pick, vj: vj, active: true, fixed_audio: true)
        audio_pick = create(:pick, vj: vj, active: false, fixed_audio: false)
        put :update, format: :json, id: audio_pick.to_param, fixed_audio: true

        audio_pick.reload
        video_pick.reload

        expect(audio_pick.active).to be_falsey
        expect(audio_pick.fixed_audio).to be_truthy

        expect(video_pick.active).to be_truthy
        expect(video_pick.fixed_audio).to be_falsey

      end

    end

  end #describe PUT update

end
