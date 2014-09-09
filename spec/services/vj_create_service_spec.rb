require 'spec_helper'

describe VjCreateService do
  it "it updates the timeline when setting other vjs to pending on create new vj" do
    user = create(:user)
    channel = create(:channel)
    @vj = create(:vj, status: :live, user: user, channel: channel)
    timeline = @vj.timeline
    VjCreateService.new(ActionController::Parameters.new({channel_name: channel.to_param}), user).run
    timeline.reload
    expect(timeline.status).to eq("pending")
  end
end
