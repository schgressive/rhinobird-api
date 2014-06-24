class ShareTwitterService

  def initialize(user, stream)
    @stream = stream
    @user = user
    init_client
  end

  def run
    @client.update("I'm starting a new live stream")
  end

  private

  def init_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TW_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TW_CONSUMER_SECRET"]
      config.access_token        = @user.tw_token
      config.access_token_secret = @user.tw_secret
    end
  end
end
