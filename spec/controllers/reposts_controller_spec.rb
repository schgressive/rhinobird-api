require 'spec_helper'

describe Api::RepostsController do
  login_user

  describe "POST #create" do
    it "reposts a stream" do
      stream = create(:stream)
      timeline = Timeline.last
      post :create, format: :json, timeline_id: timeline.id
      repost = assigns(:repost)
      expect(Timeline.count).to eq 2
      expect(Timeline.last.resource_id).to eq repost.id
      expect(Timeline.last.resource_type).to eq "Repost"
      expect(timeline.id).to eq repost.timeline_id
    end
  end
end
