require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'a1m1k8kIJWN2jDxNRfJw'
  config.consumer_secret = 'B5CVod8Z7ikjZpwTpm4c52I2SOw0oPSpD12rAdotL8'
  config.access_token = '13524512-j7W4syFfhNKLHxdg6chte0n53lpWUHlbQJUNInESs'
  config.access_token_secret = 'PrLr3e5PAHJEm1hpQESpa0GNwqv9vuq0MhoE0GS7id4cI'
end

search_term = URI::encode('bemyeyes')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
