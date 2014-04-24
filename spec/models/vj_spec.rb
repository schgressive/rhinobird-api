require 'spec_helper'

describe Vj do
  it "has a valid factory" do
    vj = build(:vj)
    expect(vj).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:channel_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:channel_id).scoped_to(:user_id) }
  end

  describe "Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:channel) }
    it { should have_many(:picks) }
  end

  describe "FriendlyId" do
    it "assigns a md5 hash as ID" do
      vj = create(:vj)
      expect(vj.to_param).to match(/^[a-zA-Z0-9]{32}$/)
    end
  end

end
