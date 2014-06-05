require 'spec_helper'

describe EventTrackerService do
  before :each do
    @vj = create(:vj, status: :live)
  end

  it "returns a correct event" do
    @pick = create(:pick, active_audio: true, vj: @vj)
    Timecop.freeze(Time.now) do
      event = EventTrackerService.new(@pick).run[:audio]
      expect(event.vj_id).to eq(@pick.vj_id)
      expect(event.stream_id).to eq(@pick.stream_id)
      expect(event.track_type).to eq("audio")
      expect(event.start_time).to eq(Time.now)
    end
  end

  it "ignores inactive picks" do
    @pick1 = create(:pick, vj: @vj)
    @pick2 = create(:pick, vj: @vj)
    @event = EventTrackerService.new(@pick1).run
    @event2 = EventTrackerService.new(@pick2).run
    expect(@event.size).to eq(0)
    expect(@event2.size).to eq(0)
    expect(Event.count).to eq(0)
  end

  it "ignores picks if vj is not live" do
    vj = create(:vj, status: "created")
    pick1 = create(:pick, vj: vj, active: true)
    @event = EventTrackerService.new(pick1).run

    expect(Event.count).to eq 0
  end

  it "sets duration to correct track type" do
    @video1 = create(:pick, active: true, vj: @vj)
    @video2 = create(:pick, active: true, vj: @vj)
    @audio1 = create(:pick, active_audio: true, vj: @vj)
    @event = EventTrackerService.new(@video1).run[:video]
    Timecop.freeze(Time.now + 60.seconds) do
      @event2 = EventTrackerService.new(@audio1).run[:audio]
      @event3 = EventTrackerService.new(@video2).run[:video]
    end
    @event.reload
    @event2.reload
    expect(@event.duration).to eq(60)
    expect(@event2.duration).to eq(0)
  end

  it "sets the duration of the previous stream" do
    stream = create(:stream, created_at: Time.now - 90.seconds)
    @pick1 = create(:pick, active: true, vj: @vj, stream: stream)
    @pick2 = create(:pick, active: true, vj: @vj)
    @event = EventTrackerService.new(@pick1).run[:video]
    @current_time = Time.now.utc
    Timecop.freeze(Time.now + 60.seconds) do
      @event2 = EventTrackerService.new(@pick2).run
    end
    @event.reload
    expect(@event.start_time.to_s(:api)).to eq(@current_time.to_s(:api))
    expect(@event.duration).to eq(60)
  end

  it "sets duration of the same pick" do
    @pick1 = create(:pick, active: true, vj: @vj)
    Timecop.freeze(Time.now + 60.seconds) do
      @event = EventTrackerService.new(@pick1).run[:video]
    end
    Timecop.freeze(Time.now + 61.seconds) do
      @event1 = EventTrackerService.new(@pick1).run[:video]
    end
    Timecop.freeze(Time.now + 62.seconds) do
      @event2 = EventTrackerService.new(@pick1).run[:video]
    end
    Timecop.freeze(Time.now + 63.seconds) do
      @event3 = EventTrackerService.new(@pick1).run[:video]
    end
    @event.reload
    @event1.reload
    @event2.reload
    @event3.reload
    expect(@event.duration).to eq(1)
    expect(@event1.duration).to eq(1)
    expect(@event2.duration).to eq(1)
    expect(@event3.duration).to eq(0)
  end
end
