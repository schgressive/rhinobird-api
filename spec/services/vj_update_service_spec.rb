require 'spec_helper'

describe VjUpdateService do

  context "when finishing VJ (pending)" do
    it "sets the duration of the last audio and video event" do
      @vj = create(:vj)
      @audio_event = create(:event, vj: @vj, duration: nil, track_type: :audio)
      @video_event = create(:event, vj: @vj, duration: nil, track_type: :video)
      Timecop.freeze(Time.now + 60.seconds) do
        VjUpdateService.new(@vj, ActionController::Parameters.new({status: "pending"}).permit(:status)).run
      end
      @audio_event.reload
      @video_event.reload
      expect(@audio_event.duration).to be >= 60
      expect(@audio_event.duration).to be <= 62
      expect(@video_event.duration).to be >= 60
      expect(@video_event.duration).to be <= 62
    end
  end
end
