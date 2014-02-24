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

end
