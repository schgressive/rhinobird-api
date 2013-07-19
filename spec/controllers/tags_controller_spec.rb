require 'spec_helper'

describe TagsController do

  describe "POST #create" do

    before do
      @stream = create(:stream)
      @post_hash = {name: 'this_tag', stream_id: @stream.id, format: :json}

      post :create, @post_hash
      @json_tag = JSON.parse(response.body)
    end

    it "returns success code" do
      expect(response.status).to be(201)
    end

    it "increments the tag count" do
      expect{post :create, {name: 'another_tag', stream_id: @stream.id}}.to change(@stream.tags, :count).by(1)
    end

    it "returns correct content type" do
      expect(response.header['Content-Type']).to include("application/json")
    end

    it "returns the updated stream object" do
      expect(@json_tag["id"]).to eq(@stream.to_param)
      expect(@json_tag["tags"]).to include("this_tag")
    end

  end

  describe "DELETE #destroy" do
    before(:each) do
      @stream = create(:stream, tags: [create(:tag, name: "mytag")])
    end

    it "returns success code" do
      delete :destroy, {stream_id: @stream.id, id: "mytag" }
      expect(response.status).to be(204)
    end

    it "keeps the removed tag in the database" do
      expect{delete :destroy, {stream_id: @stream.id, id: "mytag" }}.not_to change{Tag.count}.by(-1)
    end

    it "removes the tag from the stream" do
      expect{delete :destroy, {stream_id: @stream.id, id: "mytag" }}.to change{@stream.tags.count}.by(-1)
    end
  end


end
