module Owly
  # Client class used to interact with the ow.ly API. Requires an API token.
  #
  # @see http://ow.ly/api-docs
  class Client
    include ::WrappyAPI

    attr_reader :config

    def initialize(&block)
      @config = Configuration.new
      @config.configure(&block) if block_given?
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
      params = {}
      params["apiKey"] = ENV.fetch('OWLY_API_KEY')
      params['fileName'] = File.basename(file)
      params['uploaded_file'] = file
      result = post('photo/upload', params, {:content_type => :multipart})
      if result
        result['static_url'] = 'http://static.ow.ly/photos/normal/%s%s' % [result['hash'], File.extname(file)]
      end
      result
    end

    protected

    def default_handler
      if response.content_type == 'application/json'
        body = JSON.parse(response.body)
        if body['error']
          @errors << body['error']
          false
        else
          body['results']
        end
      end
    end

    # Required to upload photos to ow.ly
    # 
    # @see http://ow.ly/api-docs
    # @param [Hash] params
    def set_headers(params = {})
      uri = 'https://api.twitter.com/1.1/account/verify_credentials.json'
      credentials = {}
      credentials[:consumer_key] = ENV.fetch('HOOTSUITE_TWITTER_API_KEY')
      credentials[:consumer_secret] = ENV.fetch('HOOTSUITE_TWITTER_API_SECRET')
      credentials[:token] = '4893474636-2eqUyMHXkgc9gQajPmLOAyrp1WsDhd1yNbLGZtk'
      credentials[:token_secret] = 'cLWIZOe9dDxcruJszUhVyCuNwPVQqqhfUWI954LXCAIIW'
      auth = SimpleOAuth::Header.new('get', uri, {}, credentials)
      @request['Authorization'] = auth.to_s
      super
    end
  end
end
