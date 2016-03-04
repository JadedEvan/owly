module Owly
  # Client class used to interact with the ow.ly API. Requires an API token.
  #
  # @see http://ow.ly/api-docs
  class Client

    # @param [String] token
    # @param [String] secret
    def initialize(token, secret)
      @oauth_token, @oauth_secret = token, secret
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
    def upload_photo(file)
      unless [File, IO].include?(file.class)
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
      credentials[:consumer_key] = ENV.fetch('HOOTSUITE_TWITTER_API_KEY')
      credentials[:consumer_secret] = ENV.fetch('HOOTSUITE_TWITTER_API_SECRET')
      credentials[:token] = @oauth_token
      credentials[:token_secret] = @oauth_secret
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
