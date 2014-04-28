require 'spec_helper'

describe Vj do
  it "has a valid factory" do
    vj = build(:vj)
    expect(vj).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:channel_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
    it { should have_many(:picks) }
    it { should have_many(:events) }

    it "validates that the user and channel are unique in created or live state" do
      user = create(:user)
      channel = create(:channel)
      vj = create(:vj, user: user, channel: channel, status: :live )
      vj = build(:vj, user: user, channel: channel)
      expect(vj).to be_invalid
      vj = build(:vj, user: user, channel: channel, status: :live)
      expect(vj).to be_invalid

      channel = create(:channel, name: "anotherchannel")
      vj = create(:vj, user: user, channel: channel, status: :pending )
      vj = build(:vj, user: user, channel: channel)
      expect(vj).to be_valid
    end
  end

  describe "FriendlyId" do
    it "assigns a md5 hash as ID" do
      vj = create(:vj)
      expect(vj.to_param).to match(/^[a-zA-Z0-9]{32}$/)
    end
  end


end
