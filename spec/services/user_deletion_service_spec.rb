require 'spec_helper'

RSpec.describe UserDeletionService, type: :Service do

  let(:user) { create(:user) }

  context "user data" do
    it "sets the user destruction time" do
      Timecop.freeze
      UserDeletionService.new.perform(user.id, false)
      user.reload
      expect(user.destruction_time.to_i).to eq(12.days.from_now.to_i)
    end

    it "sets the user status as for_deletion" do
      UserDeletionService.new.perform(user.id, false)
      user.reload
      expect(user.status).to eq "for_deletion"
    end

    it "deletes the user" do
      UserDeletionService.new.perform(user.id, true)
      expect{User.find(user.id)}.to raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context "related data" do
    it "marks streams for_deletion" do
      stream = create(:stream, user: user)
      UserDeletionService.new.perform(user.id, false)
      stream.reload
      expect(stream.status).to eq "for_deletion"
    end

    it "deletes streams" do
      stream = create(:stream, user: user)
      expect{UserDeletionService.new.perform(user.id, true)}.to change{Stream.count}.by(-1)
      expect{Stream.find(stream.id)}.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "deletes vjs" do
      vj = create(:vj, user: user)
      expect{UserDeletionService.new.perform(user.id, true)}.to change{Vj.count}.by(-1)
      expect{Vj.find(vj.id)}.to raise_exception(ActiveRecord::RecordNotFound)
    end

    it "marks vjs for_deletion" do
      vj = create(:vj, user: user)
      expect{UserDeletionService.new.perform(user.id, false)}.to change{Timeline.count}.by(-1)
      vj.reload
      expect(vj.status).to eq "for_deletion"
    end
  end

end
