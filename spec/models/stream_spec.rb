require 'spec_helper'

describe Stream do
  it "has a valid factory" do
    stream = build(:stream)
    expect(stream).to be_valid
  end

  context "Attachments" do
    it { should have_attached_file(:thumbnail)}
  end

  describe "relations" do
    it { should belong_to(:channel) }
    it { should have_and_belong_to_many(:tags) }
  end


  context "validations" do
    it "doesn't require a title" do
      stream = build(:stream, title: '')
      expect(stream).to be_valid
    end
  end

  describe "#add_tags" do

    it "assigns 2 tags" do
      @stream = create(:stream)
      @stream.add_tags("grunge,rock , grunge")
      expect(@stream.tags).to have(2).items
    end

    it "assigns 2 tags" do
      @stream = create(:stream)
      @stream.add_tags("grunge,rock")
      expect(@stream.tags).to have(2).items
    end

  end

  describe "#set_channel" do

    before(:each) do
      @stream = create(:stream)
      @channel = create(:channel, name: "concerts")
    end

    it "assigns to the channel by name" do
      @stream.set_channel("concerts")
      expect(@stream.channel).to eql(@channel)
    end

  end

  describe "#add_tag" do
    before(:each) do
      @stream = create(:stream)
    end

    it "assigns a new tag" do
      expect{@stream.add_tag("new_tag")}.to change{@stream.tags.count}.by(1)
    end

    it "creates the tag if it doesn't exist" do
      expect{@stream.add_tag("new_tag")}.to change{Tag.count}.by(1)
    end

    it "adds an existing tag to the stream" do
      @tag = create(:tag, name: "new_tag")
      expect{@stream.add_tag("new_tag")}.to change{Tag.count}.by(0)
    end

    it "skips a tag if its already added" do
      @tag = create(:tag, name: "new_tag")
      @stream.add_tag @tag.name
      expect{@stream.add_tag("new_tag")}.to change{@stream.tags.count}.by(0)
      expect{@stream.add_tag("new_tag")}.to change{Tag.count}.by(0)
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
      expect(stream.thumbnail.exists?).to be_true
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

  describe "get streams by channel" do

    before do
      @lonely_stream = create(:stream)
      @stream1 = create(:stream)
      @stream2 = create(:stream)
      channel = create(:channel, streams: [@stream1, @stream2])
      @streams = Stream.by_channel(channel)
    end

    it "returns only streams of the channel" do
      expect(@streams).to have(2).elements
      expect(@streams).to include(@stream1)
      expect(@streams).to include(@stream2)
    end

    it "filters streams not in this channel" do
      expect(@streams).not_to include(@lonely_stream)
    end
  end

end
