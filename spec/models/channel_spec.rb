require 'spec_helper'

describe Channel do

  it "has a valid factory" do
    channel = build(:channel)
    expect(channel).to be_valid
  end

  context "validations" do
    it "requires an identifier" do
      channel = build(:channel, identifier: '')
      expect(channel).to be_invalid
    end

    it "is invalid if identifier exists" do
      create(:channel, identifier: 'New Concert')
      channel = build(:channel, identifier: 'New Concert')
      expect(channel).to be_invalid
    end
  end

  context "creating channels" do
    let(:channel) { create(:channel) }

    it "assigns a new MD5 for the ID" do
      expect(channel.id).to match(/^[a-zA-Z0-9]{32}$/)
    end
  end


end
