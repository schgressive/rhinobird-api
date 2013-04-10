require 'spec_helper'

describe Stream do

  it "has a valid factory" do 
    stream = build(:stream)
    expect(stream).to be_valid
  end

  context "validations" do
    it "requires a Description" do
      stream = build(:stream, desc: '')
      expect(stream).to be_invalid
    end

    it "requires a title" do
      stream = build(:stream, title: '')
      expect(stream).to be_invalid
    end
  end

  context "creating streams" do
    let(:stream) { create(:stream) }

    it "assigns a new MD5 for the ID" do
      expect(stream.id).to match(/^[a-zA-Z0-9]{32}$/)
    end

    it "sets the started_on timestamp" do
      expect(stream.started_on).not_to be_nil
      difference = Time.now - stream.started_on
      expect(difference).to be < 2 #less than 2 seconds
    end
  end

end
