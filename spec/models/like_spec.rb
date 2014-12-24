require 'spec_helper'

RSpec.describe Like, type: :model do

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

    it "can like a vj" do
      vj = create(:vj)
      Like.track(user, vj)
      expect(Like.count).to eq(1)

    end
  end

  describe "#untrack" do
    let(:user) { create(:user) }

    it "unlikes a new object" do
      stream = create(:stream)
      like = create(:like, likeable: stream, user: user)
      Like.untrack(user, stream)
      expect(Like.count).to eq(0)
    end

  end
end
