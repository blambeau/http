require 'http/version'
require 'http/verbs'
require 'http/chainable'
require 'http/client'
require 'http/mime_type'
require 'http/parameters'
require 'http/response'

# THIS IS ENTIRELY TEMPORARY, I ASSURE YOU
require 'net/https'
require 'uri'

# Http, it can be simple!
module Http
  extend Chainable

  class << self

    def delegate
      @delegate ||= begin
        handler = Client.new
        handler = Options::Headers.new(handler, default_headers)
        handler = Options::Response.new(handler)
        handler
      end
    end

    def default_headers
      @default_headers ||= {}
    end

    def default_headers=(headers)
      @default_headers = headers
    end

  end

end
