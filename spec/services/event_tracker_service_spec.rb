require 'spec_helper'

describe EventTrackerService do
  before :each do
    @vj = create(:vj, status: :live)
  end

  it "generates audio and video events" do
    @pick = create(:pick, active: true, vj: @vj)
    Timecop.freeze(Time.now) do
      srv = EventTrackerService.new(@pick).run
      expect(Event.count).to eq(2)
      expect(srv.audio_event.vj_id).to eq(@pick.vj_id)
      expect(srv.audio_event.stream_id).to eq(@pick.stream_id)
      expect(srv.audio_event.track_type).to eq("audio")
      expect(srv.audio_event.start_time).to eq(Time.now)
      expect(srv.video_event.vj_id).to eq(@pick.vj_id)
      expect(srv.video_event.stream_id).to eq(@pick.stream_id)
      expect(srv.video_event.track_type).to eq("video")
      expect(srv.video_event.start_time).to eq(Time.now)
    end
  end

  it "ignores inactive picks" do
    @pick1 = create(:pick, vj: @vj)
    @pick2 = create(:pick, vj: @vj, fixed_audio: true)
    EventTrackerService.new(@pick1).run
    EventTrackerService.new(@pick2).run
    expect(Event.count).to eq(0)
  end

  it "ignores picks if vj is not live" do
    vj = create(:vj, status: "created")
    pick1 = create(:pick, vj: vj, active: true)
    EventTrackerService.new(pick1).run

    expect(Event.count).to eq 0
  end

  it "sets the duration of the previous stream" do
    stream = create(:stream, created_at: Time.now - 90.seconds)
    @pick1 = create(:pick, active: true, vj: @vj, stream: stream)
    @pick2 = create(:pick, active: true, vj: @vj)
    srv = EventTrackerService.new(@pick1).run
    @current_time = Time.now.utc
    Timecop.freeze(Time.now + 60.seconds) do
      EventTrackerService.new(@pick2).run
    end
    srv.video_event.reload
    srv.audio_event.reload
    expect(srv.video_event.start_time.to_s(:api)).to eq(@current_time.to_s(:api))
    expect(srv.audio_event.start_time.to_s(:api)).to eq(@current_time.to_s(:api))
    expect(srv.video_event.duration).to eq(60)
    expect(srv.audio_event.duration).to eq(60)
  end

  it "ignores events on the same pick for the same status" do
    @pick1 = create(:pick, active: true, vj: @vj)
    Timecop.freeze(Time.now + 60.seconds) do
      EventTrackerService.new(@pick1).run
    end
    @pick1.fixed_audio = true
    Timecop.freeze(Time.now + 61.seconds) do
      EventTrackerService.new(@pick1).run
    end
    expect(Event.count).to eq 2
  end
end
