require 'spec_helper'

describe Api::TimelineController do
  describe "GET #index" do

    before do

      @vj_event = create(:vj)
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

    it "returns an array of timelines" do
      expect(@timelines).to have(2).items
      expect(@timelines[0]["resource_type"]).to eq("Stream")
      expect(@timelines[0]["resource"]["id"]).to eq(@stream_event.to_param)
    end

  end


end
