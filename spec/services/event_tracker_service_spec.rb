require 'spec_helper'

describe EventTrackerService do
  before :each do
    @vj = create(:vj)
  end

  it "returns a correct event" do
    @pick = create(:pick, active_audio: true)
    Timecop.freeze(Time.now) do
      event = EventTrackerService.new(@pick).execute[:audio]
      expect(event.vj_id).to eq(@pick.vj_id)
      expect(event.stream_id).to eq(@pick.stream_id)
      expect(event.track_type).to eq("audio")
      expect(event.start_time).to eq(Time.now)
    end
  end

  it "ignores inactive picks" do
    @pick1 = create(:pick, vj: @vj)
    @pick2 = create(:pick, vj: @vj)
    @event = EventTrackerService.new(@pick1).execute
    @event2 = EventTrackerService.new(@pick2).execute
    expect(@event.size).to eq(0)
    expect(@event2.size).to eq(0)
    expect(Event.count).to eq(0)
  end

  it "sets duration to correct track type" do
    @video1 = create(:pick, active: true, vj: @vj)
    @video2 = create(:pick, active: true, vj: @vj)
    @audio1 = create(:pick, active_audio: true, vj: @vj)
    Timecop.freeze(@video1.stream.created_at + 60.seconds) do
      @event = EventTrackerService.new(@video1).execute[:video]
      @event2 = EventTrackerService.new(@audio1).execute[:audio]
      @event3 = EventTrackerService.new(@video2).execute[:video]
    end
    @event.reload
    @event2.reload
    expect(@event.duration).to eq(60)
    expect(@event2.duration).to eq(0)
  end

  it "sets the duration of the previous stream" do
    @pick1 = create(:pick, active: true, vj: @vj)
    @pick2 = create(:pick, active: true, vj: @vj)
    Timecop.freeze(@pick1.stream.created_at + 60.seconds) do
      @event = EventTrackerService.new(@pick1).execute[:video]
      @event2 = EventTrackerService.new(@pick2).execute
    end
    @event.reload
    expect(@event.duration).to eq(60)
  end
end
