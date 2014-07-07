require 'spec_helper'

describe Pick do
  it "has a valid factory" do
    pick = build(:pick)
    expect(pick).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:vj_id) }
    it { should validate_presence_of(:stream_id) }
  end

  describe "Relations" do
    it { should belong_to(:vj) }
    it { should belong_to(:stream) }
  end

  describe "FriendlyId" do
    it "assigns a md5 hash as ID" do
      pick = create(:pick)
      expect(pick.to_param).to match(/^[a-zA-Z0-9]{32}$/)
    end
  end

end
