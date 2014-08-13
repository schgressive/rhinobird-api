require 'spec_helper'

describe Api::TimelineController do
  describe "GET #index" do

    before do

      Timecop.freeze(Time.now-20.seconds) do
        @promoted_event = create(:stream, promoted:true)
      end

      @vj_event = create(:vj)
      @stream_event = create(:pending_stream)

      Timecop.freeze(Time.now+10.seconds) do
        @stream_event = create(:stream)
      end

      get :index, format: :json
      @timelines = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(200)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns an array of timelines with the promoted first" do
      expect(@timelines).to have(3).items
      expect(@timelines[0]["resource_type"]).to eq("Stream")
      expect(@timelines[0]["resource"]["id"]).to eq(@promoted_event.to_param)
      expect(@timelines[1]["resource"]["id"]).to eq(@stream_event.to_param)
    end

  end


end
