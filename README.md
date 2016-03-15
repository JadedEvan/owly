# ow.ly

Ruby implementation around the [ow.ly API](http://ow.ly/api-docs). Leverages [Faraday](https://github.com/lostisland/faraday) and [Net::HTTP](http://ruby-doc.org/stdlib-2.3.0/libdoc/net/http/rdoc/index.html) for HTTP interactions.

This implementation currently only supports photo uploads.

## Requirements

Usage requires an Ow.ly API key. This key must be set as an environment variable +OWLY_API_KEY+.

## Usage

To upload a photo ow.ly requires that you verify your identity through Twitter. As such, it will require a valid Twitter OAuth token and Twitter OAuth token secret to use. See the [ow.ly docs](http://ow.ly/api-docs) for more information.

Create a {Owly::Client} and upload a photo:

    @client = Owly::Client.new do |c|
      c.consumer_key = 'twitter-application-key'
      c.consumer_secret = 'twitter-application-secret'
      c.oauth_token = 'my-twitter-oauth-token'
      c.oauth_secret = 'my-twitter-oauth-secret'
      c.api_key = '123456789'
    end

    # Read a file to upload
    @file = File.open('/path/to/allthethings.jpg', 'r')
    @client.upload_photo(@file)
    {"hash"=>"hijnz",
     "caption"=>"placecage_400x250.jpg",
     "url"=>"http://ow.ly/i/hijnz",
     "score"=>1,
     "static_url"=>"http://static.ow.ly/photos/normal/hijnz.jpg"}

## Testing

All tests are written in RSpec

    $ bundle exec rspec spec


