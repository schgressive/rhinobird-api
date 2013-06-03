require 'spec_helper'

describe Channel do

  describe "relations" do
    it { should have_many(:streams) }
  end

  it "has a valid factory" do
    channel = build(:channel)
    expect(channel).to be_valid
  end

  describe "validations" do
    it "requires a name" do
      channel = build(:channel, name: '')
      expect(channel).to be_invalid
    end

    it "accepts alphanumeric characters as channel name(no spaces)" do
      #valid names
      expect(build(:channel, name: 'MyChannel')).to be_valid
      expect(build(:channel, name: 'mychannel19')).to be_valid
      expect(build(:channel, name: 'my_channel')).to be_valid
      #invalid names
      expect(build(:channel, name: 'My Live Stream')).to be_invalid
      expect(build(:channel, name: '1mychannel')).to be_invalid
      expect(build(:channel, name: '#my_channel')).to be_invalid
      expect(build(:channel, name: '_my_channel')).to be_invalid
    end

    it "is invalid if name exists" do
      create(:channel, name: 'NewConcert')
      channel = build(:channel, name: 'NewConcert')
      expect(channel).to be_invalid
    end
  end

  context "creating channels" do
    let(:channel) { create(:channel) }

    it "assigns a new MD5 for the hash token" do
      expect(channel.hash_token).to match(/^[a-zA-Z0-9]{32}$/)
    end
  end


end
