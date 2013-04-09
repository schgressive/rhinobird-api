require 'spec_helper'

describe Channel do

  it "has a valid factory" do 
    channel = FactoryGirl.build(:channel)
    expect(channel).to be_valid
  end

end
