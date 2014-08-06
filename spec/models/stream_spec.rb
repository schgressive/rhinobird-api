require 'spec_helper'

describe Stream do

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
    it { should have_and_belong_to_many(:tags) }
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
    describe "#increment_playcount!" do
      it "sets the count to 1 when nil" do
        stream = create(:stream)
        stream.increment_playcount!
        expect(stream.playcount).to eq(1)
      end

      it "increments the count by 1" do
        stream = create(:stream, playcount: 3)
        stream.increment_playcount!
        expect(stream.playcount).to eq(4)
      end
    end

  end

  describe "defaults" do
    it "should have the created status" do
      stream = create(:stream)
      expect(stream.get_status).to eq(:created)
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

  context "Deleting streams" do
    it "destroys the associated timeline" do
      stream = create(:stream)
      expect{stream.destroy}.to change{Timeline.count}.from(1).to(0)
    end
  end

end
