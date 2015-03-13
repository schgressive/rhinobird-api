require 'spec_helper'

describe ShareTwitterService do
  let(:user) { create(:user) }
  let(:stream) { create(:live_stream, caption: "Testing Live!") }

  before(:each) do
    stub_request(:post, /api.twitter.com\/oauth2\/token/).
      with(:body => "grant_type=client_credentials",
           :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  it "creates a tweet with a custom text" do

    # this should be ignored
    user.custom_tweet = "Custom tweet"
    user.enable_custom_tweet = true
    user.save!

    stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
       with(:body => {"status"=> /\|LIVE NOW\| Testing Live/ }).
      to_return(status: 200, body: File.open(File.join(Rails.root, '/spec/support/fixtures/twitter_update.json')).read, headers: {})

    ShareTwitterService.new(user, stream).run
  end

  it "creates a tweet correctly using the caption" do

    stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
       with(:body => {"status"=> /Testing Live/ }).
      to_return(status: 200, body: File.open(File.join(Rails.root, '/spec/support/fixtures/twitter_update.json')).read, headers: {})

    ShareTwitterService.new(user, stream).run
  end
end
