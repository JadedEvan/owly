module Owly
  # Client class used to interact with the ow.ly API. Requires an ow.ly API token.
  #
  # @example create a new client
  #  @client = Owly::Client.new do |c|
  #    c.consumer_key = 'twitter-application-key'
  #    c.consumer_secret = 'twitter-application-secret'
  #    c.oauth_token = 'my-twitter-oauth-token'
  #    c.oauth_secret = 'my-twitter-oauth-secret'
  #    c.api_key = '123456789'
  #  end
  #
  # @see http://ow.ly/api-docs
  class Client

    attr_accessor :oauth_token, :oauth_secret, :api_key, :consumer_key, :consumer_secret

    # Creates a new client. The OAuth token and secret are valid Twitter OAuth
    # credentials that are used to verify the Twitter account before using the
    # ow.ly API. See the [ow.ly docs](http://ow.ly/api-docs) for more
    # information
    #
    # @param [Proc] block
    def initialize(&block)
      yield self if block_given?
    end

    # Uploads a file through the API
    #
    # @example uploading a file
    #   file = File.open('/path/to/file.jpg', 'r+')
    #   @result = @client.upload_photo(file)
    #   {"hash"=>"hijnz",
    #    "caption"=>"placecage_400x250.jpg",
    #    "url"=>"http://ow.ly/i/hijnz",
    #    "score"=>1,
    #    "static_url"=>"http://static.ow.ly/photos/normal/hijnz.jpg"}
    #
    # @param [File, IO] 
    # @return [Hash] if upload successful
    # @return [false] if upload failed
    # @raise [Exception]
    # @raise [KeyError] if +ENV['OWLY_API_KEY']+ is not available
    def upload_photo(file)
      unless [File, IO, Tempfile].include?(file.class)
        raise "invalid file supplied. Must be a File or IO object"
      end
      ext = File.extname(file)
      params = {}
      params["apiKey"] = ENV.fetch('OWLY_API_KEY')
      params['fileName'] = File.basename(file)
      params['uploaded_file'] = Faraday::UploadIO.new(file.path, mime_type(ext))
      response = connection.post do |req|
        req.url '/api/1.1/photo/upload'
        req.body = params
        req.headers['Authorization'] = twitter_headers
        req.headers['Content-Type'] = 'multipart/form-data'
      end
      if response.success?
        result = response.body['results']
        result['static_url'] = 'http://static.ow.ly/photos/normal/%s%s' % [result['hash'], ext]
        result
      else
        false
      end
    end

    # Return a mime-type for a small set of known file extensions
    #
    # @param [String] ext
    def mime_type(ext)
      case ext
      when ".jpg" then "image/jpg"
      when ".gif" then "image/gif"
      when ".png" then "image/png"
      when ".tif" then "image/tif"
      end
    end

    protected

    # Generates headers required to authorize photo uloads to owly
    # 
    # @see http://ow.ly/api-docs
    # @param [Hash] params
    def twitter_headers(params = {})
      uri = 'https://api.twitter.com/1.1/account/verify_credentials.json'
      credentials = {}
      credentials[:consumer_key] = consumer_key
      credentials[:consumer_secret] = consumer_secret
      credentials[:token] = oauth_token
      credentials[:token_secret] = oauth_secret
      ::SimpleOAuth::Header.new('get', uri, {}, credentials).to_s
    end

    private

    # Returns the Faraday HTTP connection
    #
    # @return [Faraday]
    def connection
      @connection = ::Faraday.new(:url => 'http://ow.ly') do |faraday|
        faraday.request :multipart
        faraday.adapter Faraday.default_adapter
        faraday.response :json
      end
    end
  end
end
