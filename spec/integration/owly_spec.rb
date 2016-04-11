require 'spec_helper'
require 'uri'

describe 'Owly spec', :type => :integration do
  before(:all) do
    @client = Owly::Client.new do |c|
      c.oauth_token = ENV.fetch('HOOTSUITE_TWITTER_OAUTH_TOKEN')
      c.oauth_secret = ENV.fetch('HOOTSUITE_TWITTER_OAUTH_TOKEN_SECRET')
      c.api_key = ENV.fetch('OWLY_API_KEY')
      c.consumer_key = ENV.fetch('HOOTSUITE_TWITTER_API_KEY')
      c.consumer_secret = ENV.fetch('HOOTSUITE_TWITTER_API_SECRET')
    end
    @file = File.open(File.join(SPEC_DIR, 'files', 'placecage_400x250.jpg'), 'r')
  end

  include_context 'webmock disabled'

  describe '#upload_photo' do
    context 'with valid credentials' do
      context 'with valid file' do
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
      context 'with invalid file' do
        before(:all) do
          @bad_file = File.open(File.join(SPEC_DIR, 'files', 'teapot.txt'), 'r')
        end
        it 'raises error' do
          expect{@client.upload_photo(@bad_file)}.to raise_error Owly::Error
        end
      end
    end
    context 'with invalid credentials' do
      before(:all) do
        @bad_client = Owly::Client.new do |c|
          c.oauth_token = 123
          c.oauth_secret = 123
          c.api_key = '11223344'
        end
      end
      it 'raises error' do
        expect{@bad_client.upload_photo(@file)}.to raise_error Owly::Error
      end
    end
  end
end
