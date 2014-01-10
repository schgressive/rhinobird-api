require 'spec_helper'

describe StreamPool do
  it "has a valid factory" do
    stream = build(:stream_pool)
    expect(stream).to be_valid
  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:stream) }
  end


  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:stream_id) }
  end

  describe "defaults" do
    it "defaults the active flag to false" do
      stream = create(:stream_pool)
      expect(stream.active).to be_false
    end
  end

  describe "methods" do

    context "#set_active" do

      before(:each) do
        @user = create(:user)
      end

      it "changes the state of the stream pool" do
        stream = create(:stream_pool, user: @user, active: false, stream: create(:live_stream))
        stream.set_active(true)
        expect(stream.active).to be_true

        stream.set_active(false)
        expect(stream.active).to be_false
      end

      it "can't change the state of a non live stream" do
        offline_stream = create(:archived_stream)
        stream = create(:stream_pool, user: @user, active: false, stream: offline_stream)

        expect(stream.set_active(true)).to be_false
      end

      it "inactivates other streams" do
        unrelated_stream = create(:stream_pool, active: true, stream: create(:live_stream))
        active_stream = create(:stream_pool, user: @user, active: true, stream: create(:live_stream))
        stream = create(:stream_pool, user: @user, active: false, stream: create(:live_stream))
        stream.set_active(true)

        expect(active_stream.reload.active).to be_false
        expect(stream.reload.active).to be_true
        expect(unrelated_stream.reload.active).to be_true
      end

    end

  end

end
