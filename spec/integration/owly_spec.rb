require 'spec_helper'
require 'uri'

describe 'Owly spec', :type => :integration do
  before(:all) do
    token = ENV.fetch('OWLY_TWITTER_OAUTH_TOKEN')
    secret = ENV.fetch('OWLY_TWITTER_OAUTH_TOKEN_SECRET')
    @client = Owly::Client.new(token, secret)
    path = File.dirname(File.expand_path(__FILE__))
    @file = File.open(File.join(path, '../files', 'placecage_400x250.jpg'), 'r')
  end

  include_context 'webmock disabled'

  describe '#upload_photo' do
    before(:all) do
      @result = @client.upload_photo(@file)
    end

    it 'returns a hash' do
      expect(@result).to be_a Hash
    end

    it 'contains static_url' do
      expect(@result.keys).to include "static_url"
    end

    it 'returns a valid static_url' do
      expect{URI.parse(@result['static_url'])}.not_to raise_error
      expect(URI.parse(@result['static_url'])).to be_a URI::HTTP
    end
  end
end
