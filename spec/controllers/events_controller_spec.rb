require 'spec_helper'

describe Api::EventsController do
  describe "GET #index" do

    context "by vj" do
      before do
        @event1 = create(:event)
        @event2 = create(:event)
        @vj = create(:vj, events: [@event1, @event2])
        get :index, format: :json, vj_id: @vj.to_param
        @json = JSON.parse(response.body)

      end

      it "returns ordered by date ascending events" do
        expect(@json.length).to eq(2)
        expect(@json[0]["id"]).to eq(@event1.id)
        expect(@json[1]["id"]).to eq(@event2.id)
      end

      it "embeds the stream" do
        expect(@json[0]["stream"]["archived_url"]).to eq(@event1.stream.archived_url)
      end

      it "returns correct structure" do
        event = @json[0]
        expect(event["track_type"]).to eq(@event1.track_type)
        expect(event["start_time"]).to eq(@event1.start_time.to_s(:api))
        expect(event["duration"]).to eq(@event1.to_hms)
      end

    end
  end

end
