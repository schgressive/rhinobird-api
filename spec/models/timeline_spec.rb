require 'spec_helper'

describe Timeline do
  it "has a valid factory" do
    timeline = build(:timeline)
    expect(timeline).to be_valid
  end
end
