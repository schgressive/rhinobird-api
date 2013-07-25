require 'spec_helper'

describe User do

  it "has a valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end

  describe "Relations" do
    it { should have_many(:streams) }
  end

end
