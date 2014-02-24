require 'spec_helper'

describe VjService do
  context "activating streams" do

    before(:each) do
      @user = create(:user)
      @vj_service = VjService.new(@user)
    end

    it "changes the state of the stream pool" do
      vj_stream = create(:stream_pool, user: @user, active: false, stream: create(:live_stream))
      vj_stream = @vj_service.update({id: vj_stream.stream.to_param, active: true})
      expect(vj_stream.active).to be_true

      vj_stream = @vj_service.update({id: vj_stream.stream.to_param, active: false})
      expect(vj_stream.active).to be_false
    end

    it "can't change the state of a non live stream" do
      offline_stream = create(:archived_stream)
      vj_stream = create(:stream_pool, user: @user, active: false, stream: offline_stream)
      result = @vj_service.update({id: vj_stream.stream.to_param, active: true})

      expect(result).to be_false
    end

    it "inactivates other streams" do
      unrelated_stream = create(:stream_pool, active: true, stream: create(:live_stream))
      active_stream = create(:stream_pool, user: @user, active: true, stream: create(:live_stream))
      vj_stream = create(:stream_pool, user: @user, active: false, stream: create(:live_stream))
      @vj_service.update({id: vj_stream.stream.to_param, active: true})

      expect(active_stream.reload.active).to be_false
      expect(vj_stream.reload.active).to be_true
      expect(unrelated_stream.reload.active).to be_true
    end

  end

end

