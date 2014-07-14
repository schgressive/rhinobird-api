require 'spec_helper'

describe ShareTwitterService do
  let(:user) { create(:user) }
  let(:stream) { create(:live_stream) }

  before(:each) do
    stub_request(:post, "https://api.twitter.com/oauth2/token").
      with(:body => "grant_type=client_credentials",
           :headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => "", :headers => {})
  end

  it "creates a tweet correctly" do

    stub_request(:post, "https://api.twitter.com/1.1/statuses/update.json").
       with(:body => {"status"=>"I'm starting a new live stream"}).
      to_return(status: 200, body: File.open(File.join(Rails.root, '/spec/support/fixtures/twitter_update.json')).read, headers: {})

    ShareTwitterService.new(user, stream).run
  end
end