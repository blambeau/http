module Http
  module Chainable
    include Verbs

    # Make an HTTP request with the given verb
    def request(verb, uri, options = {})
      delegate.request verb, uri, options
    end

    # Make a request with the given headers
    def with_headers(headers)
      Options::Headers.new delegate, headers
    end
    alias_method :with, :with_headers

    # Accept the given MIME type(s)
    def accept(type)
      if type.is_a? String
        with :accept => type
      else
        mime_type = Http::MimeType[type]
        raise ArgumentError, "unknown MIME type: #{type}" unless mime_type
        with :accept => mime_type.type
      end
    end

  end
end
