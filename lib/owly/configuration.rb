module Owly
  class Configuration
    attr_accessor :api_domain, :api_version, :use_ssl

    def configure(&block)
      yield self
    end
  end
end
