require 'spec_helper'

describe Stream do

  it "has a valid factory" do 
    stream = FactoryGirl.build(:stream)
    expect(stream).to be_valid
  end

  context "validations" do
    it "requires a title" do
      stream = FactoryGirl.build(:stream, title: '')
      expect(stream).to be_invalid
    end
  end

end
