require 'spec_helper'

describe Tag do
  describe "Relations" do
    it { should have_and_belong_to_many(:streams) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name)}

    it { should validate_uniqueness_of(:name)}

    it "accepts alphanumeric characters as tag name(no spaces)" do
      #valid names
      expect(build(:tag, name: 'Mytag')).to be_valid
      expect(build(:tag, name: 'mytag19')).to be_valid
      expect(build(:tag, name: 'my_tag')).to be_valid
      #invalid names
      expect(build(:tag, name: 'My Live Stream')).to be_invalid
      expect(build(:tag, name: '1mytag')).to be_invalid
      expect(build(:tag, name: '#my_tag')).to be_invalid
      expect(build(:tag, name: '_my_tag')).to be_invalid
    end

  end
end
