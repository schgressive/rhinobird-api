class ShareTwitterService

  def initialize(user, stream)
    @stream = stream
    @user = user
  end

  def run
    init_client
    if @stream.thumbnail.present?
      temp = Tempfile.new(@stream.thumbnail.original_filename)
      @stream.thumbnail.copy_to_local_file(:large, temp.path)
      message = @client.update_with_media get_tweet_message, temp
    else
      message = @client.update get_tweet_message
    end
  rescue Twitter::Error => e
    puts "Couldn't update on twitter: #{e.message}"
  end

  private

  def get_tweet_message
    msg = "#{@stream.caption} #{@stream.full_stream_url}"
    msg
  end

  def init_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TW_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TW_CONSUMER_SECRET"]
      config.access_token        = @user.tw_token
      config.access_token_secret = @user.tw_secret
    end
  end
end
