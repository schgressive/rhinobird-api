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

    it "is invalid if name exists" do
      create(:channel, name: 'New Concert')
      channel = build(:channel, name: 'New Concert')
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
