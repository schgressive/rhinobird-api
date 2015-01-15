require 'spec_helper'

RSpec.describe User, type: :Model do

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
    it { should have_many(:vjs) }
  end

  describe "Methods" do

    context "#should_delete?" do
      let(:user) { create(:user, status: :for_deletion) }
      it "returns false" do
        expect(user.should_delete?).to eq false
      end
      it "returns true when the time has come" do
        user.destruction_time = 12.days.from_now
        Timecop.freeze(Time.now + 13.days) do
          expect(user.should_delete?).to eq true
        end
      end
    end

  end

end
