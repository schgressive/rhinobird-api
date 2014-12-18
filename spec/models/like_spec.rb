require 'spec_helper'

describe Like do
  it "has a valid factory" do
    like = build(:like)
    expect(like).to be_valid
  end

  describe "#track" do

    let(:user) { create(:user) }

    it "likes a new object" do
      stream = create(:stream)
      Like.track(user, stream)
      expect(Like.count).to eq(1)
    end

    it "ignores likes on the same object" do
      stream = create(:stream)
      Like.track(user, stream)
      Like.track(user, stream)
      expect(Like.count).to eq(1)
    end
  end
end
