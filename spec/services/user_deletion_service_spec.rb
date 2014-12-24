require 'spec_helper'

RSpec.describe UserDeletionService, type: :Service do

  let(:user) { create(:user) }

  context "user data" do
    it "sets the user destruction time" do
      Timecop.freeze
      UserDeletionService.new(user).run
      expect(user.destruction_time).to eq(12.days.from_now)
    end

    it "sets the user status as for_deletion" do
      UserDeletionService.new(user).run
      user.reload
      expect(user.status).to eq "for_deletion"
    end
  end

  context "related data" do
    it "marks streams for_deletion" do
      stream = create(:stream, user: user)
      UserDeletionService.new(user).run
      stream.reload
      expect(stream.status).to eq "for_deletion"
    end

    it "marks vjs for_deletion" do
      vj = create(:vj, user: user)
      expect{UserDeletionService.new(user).run}.to change{Timeline.count}.by(-1)
      vj.reload
      expect(vj.status).to eq "for_deletion"
    end
  end

end
