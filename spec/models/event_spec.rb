require 'spec_helper'

describe Event do
  it "has a valid factory" do
    event = build(:event)
    expect(event).to be_valid
  end

  describe "Validations" do
    it { should validate_presence_of(:vj_id) }
    it { should validate_presence_of(:stream_id) }
  end

  describe "Relations" do
    it { should belong_to(:vj) }
    it { should belong_to(:stream) }
  end

  describe "Methods" do
    context "#to_hms" do
      it "converts to string representation" do
        event = create(:event, duration: 61)
        expect(event.to_hms).to eq("00:01:01")
        event = create(:event, duration: 3620)
        expect(event.to_hms).to eq("01:00:20")
      end
    end
  end

end
