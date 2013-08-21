require 'spec_helper'

describe User do

  it "has a valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "Relations" do
    it { should have_many(:streams) }
    it { should have_many(:stream_pools) }
  end

end
