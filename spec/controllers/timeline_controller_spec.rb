require 'spec_helper'

describe Api::TimelineController do
  describe "GET #index" do

    before do
      @user = create(:user)

      # Create 2 timeline items
      Timecop.freeze(Time.now-20.seconds) do
        @promoted_event = create(:live_stream, promoted:true, user: @user)
      end
      @vj_event = create(:vj, status: :archived, user: @user)
    end

    it "returns success code" do
      get :index, format: :json
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      get :index, format: :json
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns pending resources if viewing a user" do
      # should be shown
      @stream_event = create(:pending_stream, user: @user)
      get :index, format: :json, user_id: @user.to_param, pending: "true"

      @timelines = JSON.parse(response.body)

      expect(@timelines).to have(3).items
    end

    it "returns an array of timelines with the promoted first filtering created and pending" do
      # shoud be ignored
      @stream_event = create(:pending_stream)
      @stream_created = create(:created_stream)

      Timecop.freeze(Time.now+10.seconds) do
        @stream_event = create(:live_stream)
      end

      get :index, format: :json
      @timelines = JSON.parse(response.body)

      expect(@timelines).to have(3).items
      expect(@timelines[0]["resource_type"]).to eq("Stream")
      expect(@timelines[0]["resource"]["id"]).to eq(@promoted_event.to_param)
      expect(@timelines[1]["resource"]["id"]).to eq(@stream_event.to_param)
    end

  end


end
