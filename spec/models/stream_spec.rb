require 'spec_helper'

describe Stream, type: :model do

  it "has a valid factory" do
    stream = build(:stream)
    expect(stream).to be_valid
  end

  describe "Attachments" do
    it { should have_attached_file(:thumbnail)}
  end

  describe "Relations" do
    it { should have_and_belong_to_many(:channels) }
    it { should belong_to(:user) }
  end


  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end

  describe "Methods" do

    describe "#full_stream_url" do
      it "returns the correct url" do
        stream = create(:stream)
        expect(stream.full_stream_url).to eq("http://localhost:9000/stream/#{stream.to_param}")
      end
    end

  end

  describe "defaults" do
    it "should have the created status" do
      stream = create(:stream)
      expect(stream.status).to eq("created")
    end
  end

  describe "callbacks" do

    describe "saving stream" do
      it "sets the channels on creation" do
        stream = create(:stream, caption: "Live from #rock in rio")
        expect(stream.channels.size).to eq(1)
      end

      it "update the channel list on update" do
        create(:channel, name: "lonely")
        stream = create(:stream, caption: "Live from #rock in rio")
        stream.caption = "Live from #rock in #brasil"
        expect{stream.save}.to change{Channel.count}.by(1)
        expect(stream.channels.size).to eq(2)
      end
    end
  end

  context "creating streams" do

    let(:stream) { create(:stream) }

    it "adds a thumbnail from a base64" do
      File.open(Rails.root + "spec/factories/images/rails_base64.txt") do |file|
        @image_base64 = "data:image/jpg;base64,#{file.read}"
      end
      stream.thumb = @image_base64
      stream.save!
      expect(stream.thumbnail.exists?).to be_truthy
    end

    it "assigns a new MD5 for the ID" do
      expect(stream.hash_token).to match(/^[a-zA-Z0-9]{32}$/)
    end

    it "sets the started_on timestamp" do
      expect(stream.started_on).not_to be_nil
      difference = Time.now - stream.started_on
      expect(difference).to be < 2 #less than 2 seconds
    end
  end

  context "Deleting streams" do
    it "destroys the associated timeline" do
      stream = create(:stream)
      expect{stream.destroy}.to change{Timeline.count}.from(1).to(0)
    end
  end

end
