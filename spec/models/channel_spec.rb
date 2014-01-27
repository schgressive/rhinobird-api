require 'spec_helper'

describe Channel do

  describe "relations" do
    it { should have_and_belong_to_many(:streams) }
  end

  it "has a valid factory" do
    channel = build(:channel)
    expect(channel).to be_valid
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

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

  end

  describe "methods" do

    describe "#get_channels" do

      it "returns channel objects" do
        channel = create(:channel, name: 'rock')
        channels = Channel.get_channels("Live from #woodstock #ROCK #,nothing")

        expect(channels.size).to eq(2)
        expect(channels).to include(channel)
        expect(Channel.count).to eq(2)
      end

    end

  end


end
